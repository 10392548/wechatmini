const api = require('../../api/index')

Page({
  data: {
    // 地图相关数据
    longitude: 116.397428, // 默认经度（北京）
    latitude: 39.90923,    // 默认纬度（北京）
    scale: 16,             // 缩放级别
    markers: [],           // 标记点
    polyline: [],          // 轨迹路线
    distance: 0,           // 运动距离（km）
    duration: 0,           // 运动时长（分钟）
    showHeatmap: false,    // 是否显示热力图

    // 新增数据
    temperature: 38.5,     // 当前温度
    currentStatus: {       // 当前状态
      icon: '🏃',
      text: '奔跑'
    },
    runningTime: 0,        // 奔腾时长（分钟）
    walkingTime: 0,        // 行走时长（分钟）
    staticTime: 0,         // 静止时长（分钟）
    activityDetails: [],   // 活动详情列表
    loading: true,         // 加载状态
    hasData: false         // 是否有数据
  },

  onLoad() {
    this.initMap();
    this.getLocation();
    this.loadTrackData();
  },

  // 初始化地图
  initMap() {
    this.mapCtx = wx.createMapContext('petMap', this);
  },

  // 获取当前位置（实时定位）
  getLocation() {
    wx.getLocation({
      type: 'gcj02',
      success: (res) => {
        console.log('当前位置:', res);
        this.setData({
          longitude: res.longitude,
          latitude: res.latitude
        });
      },
      fail: (err) => {
        console.error('获取位置失败:', err);
      }
    });
  },

  // 加载运动轨迹数据
  loadTrackData() {
    this.setData({ loading: true });

    // 获取当前选中的设备
    const app = getApp();
    const currentPet = app.globalData?.currentPet;

    if (!currentPet || !currentPet.device_id) {
      this.setData({ loading: false });
      wx.showToast({
        title: '请先绑定设备',
        icon: 'none'
      });
      return;
    }

    const deviceId = currentPet.device_id;

    // 调用真实 API 获取今日轨迹
    api.device.getTodayTrack(deviceId).then(res => {
      this.setData({ loading: false });

      // res 已经是数据数组（request.js 只返回 data 部分）
      if (res && res.length > 0) {
        // 数据格式转换
        const trackPoints = res.map(loc => ({
          latitude: parseFloat(loc.latitude),
          longitude: parseFloat(loc.longitude),
          timestamp: new Date(loc.recordedAt).getTime(),
          motionstate: loc.motionState || 0,
          temperature: parseFloat(loc.temperature) || 0
        }));

        // 按时间排序
        trackPoints.sort((a, b) => a.timestamp - b.timestamp);

        this.setData({
          trackPoints: trackPoints,
          hasData: true
        });

        // 更新地图中心到第一个点
        if (trackPoints.length > 0) {
          this.setData({
            longitude: trackPoints[0].longitude,
            latitude: trackPoints[0].latitude
          });
        }

        this.drawTrackLine(trackPoints);
        this.addTrackMarkers(trackPoints);
        this.calculateDistance(trackPoints);
        this.calculateActivityStats(trackPoints);
        this.generateActivityDetails(trackPoints);

        wx.showToast({
          title: `加载${trackPoints.length}个轨迹点`,
          icon: 'none'
        });
      } else {
        this.setData({
          hasData: false,
          trackPoints: []
        });
        wx.showToast({
          title: '今日暂无轨迹数据',
          icon: 'none'
        });
      }
    }).catch(err => {
      this.setData({ loading: false });
      console.error('加载轨迹失败:', err);
      wx.showToast({
        title: '加载失败，请重试',
        icon: 'none'
      });
    });
  },

  // 绘制运动轨迹路线
  drawTrackLine(points) {
    if (points.length < 2) return;

    const polyline = [{
      points: points.map(p => ({
        latitude: p.latitude,
        longitude: p.longitude
      })),
      color: '#FF8C42',
      width: 6,
      dottedLine: false,
      arrowLine: true,
      borderColor: '#FFFFFF',
      borderWidth: 2
    }];

    // 如果显示热力图，根据运动状态着色
    if (this.data.showHeatmap) {
      this.addHeatmapEffect(points);
    }

    this.setData({
      polyline: polyline
    });
  },

  // 添加热力图效果（根据运动状态着色）
  addHeatmapEffect(points) {
    const heatmapLines = [];

    // 根据运动状态生成不同颜色的线段
    const colorMap = {
      0: '#4A90E2', // 静止 - 蓝色
      1: '#7B68EE', // 行走 - 紫色
      2: '#FF8C42'  // 奔腾 - 橙色
    };

    for (let i = 0; i < points.length - 1; i++) {
      const motionstate = points[i].motionstate || 0;
      const color = colorMap[motionstate];

      heatmapLines.push({
        points: [
          { latitude: points[i].latitude, longitude: points[i].longitude },
          { latitude: points[i + 1].latitude, longitude: points[i + 1].longitude }
        ],
        color: color,
        width: 8,
        dottedLine: false
      });
    }

    this.setData({
      polyline: heatmapLines
    });
  },

  // 添加轨迹标记点（起点和终点）
  addTrackMarkers(points) {
    if (points.length === 0) return;

    const markers = [];

    // 起点标记
    markers.push({
      id: 1,
      longitude: points[0].longitude,
      latitude: points[0].latitude,
      iconPath: '/images/marker.png',
      width: 35,
      height: 35,
      title: '起点',
      callout: {
        content: '运动起点',
        color: '#ffffff',
        fontSize: 12,
        borderRadius: 8,
        bgColor: '#4CAF50',
        padding: 8,
        display: 'BYCLICK'
      }
    });

    // 终点标记
    markers.push({
      id: 2,
      longitude: points[points.length - 1].longitude,
      latitude: points[points.length - 1].latitude,
      iconPath: '/images/marker.png',
      width: 35,
      height: 35,
      title: '终点',
      callout: {
        content: '当前位置',
        color: '#ffffff',
        fontSize: 12,
        borderRadius: 8,
        bgColor: '#F44336',
        padding: 8,
        display: 'BYCLICK'
      }
    });

    this.setData({
      markers: markers
    });
  },

  // 计算运动距离
  calculateDistance(points) {
    if (points.length < 2) return;

    let totalDistance = 0;

    for (let i = 0; i < points.length - 1; i++) {
      // 只计算有运动的点（motionstate !== 0）
      if (points[i].motionstate !== 0) {
        const dist = this.getDistanceBetweenPoints(
          points[i].latitude,
          points[i].longitude,
          points[i + 1].latitude,
          points[i + 1].longitude
        );
        totalDistance += dist;
      }
    }

    // 计算运动时长（分钟）
    const duration = points.length > 1
      ? Math.round((points[points.length - 1].timestamp - points[0].timestamp) / 60000)
      : 0;

    this.setData({
      distance: totalDistance.toFixed(2),
      duration: duration
    });
  },

  // 计算运动状态统计
  calculateActivityStats(points) {
    let runningTime = 0;
    let walkingTime = 0;
    let staticTime = 0;

    for (let i = 0; i < points.length - 1; i++) {
      const timeDiff = (points[i + 1].timestamp - points[i].timestamp) / 60000; // 分钟

      switch (points[i].motionstate) {
        case 0:
          staticTime += timeDiff;
          break;
        case 1:
          walkingTime += timeDiff;
          break;
        case 2:
          runningTime += timeDiff;
          break;
      }
    }

    // 更新当前状态显示
    const lastPoint = points[points.length - 1];
    const statusMap = {
      0: { icon: 'Still', text: '静止' },
      1: { icon: 'Walking', text: '行走' },
      2: { icon: 'Running', text: '奔跑' }
    };

    this.setData({
      runningTime: Math.round(runningTime),
      walkingTime: Math.round(walkingTime),
      staticTime: Math.round(staticTime),
      currentStatus: statusMap[lastPoint.motionstate] || { icon: 'Still', text: '静止' },
      temperature: lastPoint.temperature > 0 ? lastPoint.temperature.toFixed(1) : '--'
    });
  },

  // 生成活动详情列表
  generateActivityDetails(points) {
    if (points.length === 0) return;

    const details = [];
    let currentActivity = null;
    let activityStart = null;

    const formatTime = (timestamp) => {
      const date = new Date(timestamp);
      return `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
    };

    for (let i = 0; i < points.length; i++) {
      const point = points[i];

      if (currentActivity !== point.motionstate) {
        // 结束上一个活动并生成记录
        if (currentActivity !== null && activityStart !== null) {
          const duration = Math.round((point.timestamp - activityStart) / 60000);

          if (duration > 0) {
            const activityMap = {
              0: { name: '静止', icon: 'Still', colorClass: 'yellow', bgColor: '#E8F5E9' },
              1: { name: '行走', icon: 'Walking', colorClass: 'blue', bgColor: '#E3F2FD' },
              2: { name: '奔跑', icon: 'Running', colorClass: 'green', bgColor: '#FFF3E0' }
            };

            details.push({
              name: activityMap[currentActivity].name,
              icon: activityMap[currentActivity].icon,
              colorClass: activityMap[currentActivity].colorClass,
              time: `${formatTime(activityStart)} - ${formatTime(point.timestamp)}`,
              duration: `${duration}分钟`
            });
          }
        }

        // 开始新活动
        currentActivity = point.motionstate;
        activityStart = point.timestamp;
      }
    }

    // 循环结束后，生成最后一个活动的记录
    if (currentActivity !== null && activityStart !== null) {
      const lastPoint = points[points.length - 1];
      const duration = Math.round((lastPoint.timestamp - activityStart) / 60000);

      if (duration > 0) {
        const activityMap = {
          0: { name: '静止', icon: 'Still', colorClass: 'yellow', bgColor: '#E8F5E9' },
          1: { name: '行走', icon: 'Walking', colorClass: 'blue', bgColor: '#E3F2FD' },
          2: { name: '奔跑', icon: 'Running', colorClass: 'green', bgColor: '#FFF3E0' }
        };

        details.push({
          name: activityMap[currentActivity].name,
          icon: activityMap[currentActivity].icon,
          colorClass: activityMap[currentActivity].colorClass,
          time: `${formatTime(activityStart)} - ${formatTime(lastPoint.timestamp)}`,
          duration: `${duration}分钟`
        });
      }
    }

    this.setData({
      activityDetails: details
    });
  },

  // 计算两点之间的距离（Haversine公式）
  getDistanceBetweenPoints(lat1, lon1, lat2, lon2) {
    const R = 6371; // 地球半径（km）
    const dLat = this.deg2rad(lat2 - lat1);
    const dLon = this.deg2rad(lon2 - lon1);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.deg2rad(lat1)) * Math.cos(this.deg2rad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c;

    return distance;
  },

  deg2rad(deg) {
    return deg * (Math.PI / 180);
  },

  // 居中到当前位置
  centerLocation() {
    this.mapCtx.moveToLocation();
  },

  // 切换热力图显示
  toggleHeatmap() {
    const showHeatmap = !this.data.showHeatmap;
    this.setData({
      showHeatmap: showHeatmap
    });

    // 重新绘制轨迹
    if (this.data.trackPoints && this.data.trackPoints.length > 0) {
      this.drawTrackLine(this.data.trackPoints);
    }

    wx.showToast({
      title: showHeatmap ? '状态图已开启' : '状态图已关闭',
      icon: 'none'
    });
  },

  // 刷新数据
  refreshData() {
    this.loadTrackData();
  },

  goBack() {
    wx.navigateBack();
  }
});
