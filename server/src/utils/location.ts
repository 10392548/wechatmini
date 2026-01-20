/**
 * 坐标处理工具类
 * 用于处理GPS坐标的校准、转换和距离计算
 */

export interface LocationCoordinate {
  latitude: number;
  longitude: number;
}

export const LocationUtils = {
  /**
   * 坐标校准偏移量（用于修正设备GPS漂移）
   * 根据实际测试数据调整
   */
  OFFSET: {
    lat: -0.002684,
    lng: 0.003912
  },

  /**
   * 坐标校准（固定偏移量法）
   * @param lat 原始纬度
   * @param lng 原始经度
   * @returns 校准后的坐标
   */
  calibrate(lat: number, lng: number): LocationCoordinate {
    return {
      latitude: lat + this.OFFSET.lat,
      longitude: lng + this.OFFSET.lng
    };
  },

  /**
   * 反向校准（获取原始坐标）
   * @param lat 校准后纬度
   * @param lng 校准后经度
   * @returns 原始坐标
   */
  uncalibrate(lat: number, lng: number): LocationCoordinate {
    return {
      latitude: lat - this.OFFSET.lat,
      longitude: lng - this.OFFSET.lng
    };
  },

  /**
   * 验证坐标是否有效
   * @param lat 纬度
   * @param lng 经度
   * @returns 是否有效
   */
  isValidCoordinate(lat: number, lng: number): boolean {
    return (
      typeof lat === 'number' &&
      typeof lng === 'number' &&
      !isNaN(lat) &&
      !isNaN(lng) &&
      isFinite(lat) &&
      isFinite(lng) &&
      lat >= -90 &&
      lat <= 90 &&
      lng >= -180 &&
      lng <= 180 &&
      !(lat === 0 && lng === 0) // 排除原点（通常表示无效位置）
    );
  },

  /**
   * WGS-84 转 GCJ-02（火星坐标系）
   * 腾讯地图使用GCJ-02坐标，与高德地图一致
   *
   * 注意：此函数用于将GPS原始坐标（WGS-84）转换为中国地图坐标（GCJ-02）
   * 如果坐标不在中国境内，则不进行转换
   *
   * @param wgsLat WGS-84纬度
   * @param wgsLng WGS-84经度
   * @returns GCJ-02坐标
   */
  wgs84ToGcj02(wgsLat: number, wgsLng: number): LocationCoordinate {
    // 如果不在中国境内，不需要偏移转换
    if (!this.isInChina(wgsLat, wgsLng)) {
      return { latitude: wgsLat, longitude: wgsLng };
    }

    const a = 6378245.0;
    const ee = 0.00669342162296594323;

    let dLat = this.transformLat(wgsLng - 105.0, wgsLat - 35.0);
    let dLng = this.transformLng(wgsLng - 105.0, wgsLat - 35.0);

    const radLat = wgsLat / 180.0 * Math.PI;
    let magic = Math.sin(radLat);
    magic = 1 - ee * magic * magic;
    const sqrtMagic = Math.sqrt(magic);

    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Math.PI);
    dLng = (dLng * 180.0) / (a / sqrtMagic * Math.cos(radLat) * Math.PI);

    return {
      latitude: wgsLat + dLat,
      longitude: wgsLng + dLng
    };
  },

  /**
   * 判断坐标是否在中国境内
   * @param lat 纬度
   * @param lng 经度
   * @returns 是否在中国境内
   */
  isInChina(lat: number, lng: number): boolean {
    return lat >= 3.86 && lat <= 53.55 && lng >= 73.66 && lng <= 135.05;
  },

  /**
   * 纬度转换（内部方法）
   */
  transformLat(lng: number, lat: number): number {
    let ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat +
      0.1 * lng * lng + 0.2 * Math.sqrt(Math.abs(lng));
    ret += (20.0 * Math.sin(6.0 * lng * Math.PI) + 20.0 * Math.sin(2.0 * lng * Math.PI)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(lat * Math.PI) + 40.0 * Math.sin(lat / 3.0 * Math.PI)) * 2.0 / 3.0;
    ret += (160.0 * Math.sin(lat / 12.0 * Math.PI) + 320 * Math.sin(lat * Math.PI / 30.0)) * 2.0 / 3.0;
    return ret;
  },

  /**
   * 经度转换（内部方法）
   */
  transformLng(lng: number, lat: number): number {
    let ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng +
      0.1 * lng * lng + 0.1 * Math.sqrt(Math.abs(lng));
    ret += (20.0 * Math.sin(6.0 * lng * Math.PI) + 20.0 * Math.sin(2.0 * lng * Math.PI)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(lng * Math.PI) + 40.0 * Math.sin(lng / 3.0 * Math.PI)) * 2.0 / 3.0;
    ret += (150.0 * Math.sin(lng / 12.0 * Math.PI) + 300.0 * Math.sin(lng / 30.0 * Math.PI)) * 2.0 / 3.0;
    return ret;
  },

  /**
   * 计算两点间距离（Haversine公式）
   * @param lat1 点1纬度
   * @param lng1 点1经度
   * @param lat2 点2纬度
   * @param lng2 点2经度
   * @returns 距离（米）
   */
  getDistance(lat1: number, lng1: number, lat2: number, lng2: number): number {
    const R = 6371000; // 地球半径（米）
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLng = (lng2 - lng1) * Math.PI / 180;
    const a = Math.sin(dLat / 2) ** 2 +
      Math.cos(lat1 * Math.PI / 180) *
      Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLng / 2) ** 2;
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }
};
