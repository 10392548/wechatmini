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

    // 模拟的运动轨迹数据（实际应从服务器获取）
    trackPoints: []
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

        // 添加当前位置标记
        this.addCurrentLocationMarker(res.longitude, res.latitude);
      },
      fail: (err) => {
        console.error('获取位置失败:', err);
        wx.showToast({
          title: '请授权位置信息',
          icon: 'none'
        });
      }
    });
  },

  // 添加当前位置标记
  addCurrentLocationMarker(longitude, latitude) {
    const currentMarker = {
      id: 0,
      longitude: longitude,
      latitude: latitude,
      iconPath: '/images/pet-marker.png',
      width: 40,
      height: 40,
      title: '当前位置',
      callout: {
        content: '宠物当前位置',
        color: '#ffffff',
        fontSize: 12,
        borderRadius: 8,
        bgColor: '#4A90E2',
        padding: 8,
        display: 'ALWAYS'
      }
    };

    this.setData({
      markers: [currentMarker, ...this.data.markers]
    });
  },

  // 加载运动轨迹数据
  loadTrackData() {
    // 模拟从服务器获取的轨迹数据
    // 实际应用中应该调用 API 获取真实数据
    const mockTrackPoints = this.generateMockTrack();

    this.setData({
      trackPoints: mockTrackPoints
    });

    this.drawTrackLine(mockTrackPoints);
    this.addTrackMarkers(mockTrackPoints);
    this.calculateDistance(mockTrackPoints);
  },

  // 生成模拟轨迹数据（实际应从服务器获取）
  generateMockTrack() {
    const baseLatitude = this.data.latitude;
    const baseLongitude = this.data.longitude;
    const points = [];

    // 生成一条模拟的运动轨迹（20个点）
    for (let i = 0; i < 20; i++) {
      points.push({
        latitude: baseLatitude + (Math.random() - 0.5) * 0.01,
        longitude: baseLongitude + (Math.random() - 0.5) * 0.01,
        timestamp: Date.now() - (20 - i) * 60000, // 每分钟一个点
        speed: Math.random() * 5 + 2 // 2-7 km/h
      });
    }

    return points;
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

    // 如果显示热力图，添加热力效果
    if (this.data.showHeatmap) {
      this.addHeatmapEffect(points);
    }

    this.setData({
      polyline: polyline
    });
  },

  // 添加热力图效果（通过多条不同透明度的线模拟）
  addHeatmapEffect(points) {
    const heatmapLines = [];

    // 根据速度生成不同颜色的线段
    for (let i = 0; i < points.length - 1; i++) {
      const speed = points[i].speed || 0;
      let color = '#4A90E2'; // 低速 - 蓝色

      if (speed > 5) {
        color = '#FF8C42'; // 高速 - 橙色
      } else if (speed > 3) {
        color = '#7B68EE'; // 中速 - 紫色
      }

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

    const markers = [...this.data.markers];

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
        content: '运动终点',
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
      const dist = this.getDistanceBetweenPoints(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude
      );
      totalDistance += dist;
    }

    // 计算运动时长（分钟）
    const duration = Math.round((points[points.length - 1].timestamp - points[0].timestamp) / 60000);

    this.setData({
      distance: totalDistance.toFixed(2),
      duration: duration
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
    this.mapCtx.moveToLocation({
      longitude: this.data.longitude,
      latitude: this.data.latitude
    });
  },

  // 切换热力图显示
  toggleHeatmap() {
    const showHeatmap = !this.data.showHeatmap;
    this.setData({
      showHeatmap: showHeatmap
    });

    // 重新绘制轨迹
    this.drawTrackLine(this.data.trackPoints);

    wx.showToast({
      title: showHeatmap ? '热力图已开启' : '热力图已关闭',
      icon: 'none'
    });
  },

  goBack() {
    wx.navigateBack();
  }
});
