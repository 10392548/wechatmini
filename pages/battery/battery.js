Page({
  data: {
    battery: 85,
    status: '正在使用',
    powerSaveMode: false
  },

  onLoad() {
    this.drawBatteryCircle();
  },

  drawBatteryCircle() {
    const ctx = wx.createCanvasContext('batteryCanvas');
    const centerX = 160;
    const centerY = 160;
    const radius = 120;
    const lineWidth = 20;
    const percent = this.data.battery / 100;

    // 绘制背景圆环
    ctx.setLineWidth(lineWidth);
    ctx.setStrokeStyle('rgba(255, 255, 255, 0.3)');
    ctx.setLineCap('round');
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
    ctx.stroke();

    // 绘制进度圆环
    ctx.setLineWidth(lineWidth);
    ctx.setStrokeStyle('#ffffff');
    ctx.setLineCap('round');
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * percent);
    ctx.stroke();

    ctx.draw();
  },

  togglePowerMode(e) {
    this.setData({
      powerSaveMode: e.detail.value
    });
  },

  goBack() {
    wx.navigateBack();
  }
});
