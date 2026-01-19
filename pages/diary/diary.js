// pages/diary/diary.js
Page({
  data: {
    activeTab: 0,
    diaryList: [
      {
        id: 1,
        emoji: '☀️',
        iconColor: '#FF9500',
        bgColor: 'rgba(255, 149, 0, 0.1)',
        time: '今天 08:30',
        title: '晨间散步',
        description: '实现了2km奔跑，步数稳定，状态良好'
      },
      {
        id: 2,
        emoji: '💙',
        iconColor: '#007AFF',
        bgColor: 'rgba(0, 122, 255, 0.1)',
        time: '昨天 21:00',
        title: '健康检测',
        description: '身体各项指标正常，深度睡眠维持较好水平'
      },
      {
        id: 3,
        emoji: '🌸',
        iconColor: '#AF52DE',
        bgColor: 'rgba(175, 82, 222, 0.1)',
        time: '2026年01月08日',
        title: '第一声吠叫',
        description: '随着成长的今天再度感受这个大千世界'
      }
    ],
    healthReports: [
      {
        id: 1,
        emoji: '❤️',
        iconColor: '#FF3B30',
        bgColor: 'rgba(255, 59, 48, 0.1)',
        time: '今天 10:00',
        title: '心率监测',
        description: '平均心率85次/分钟，处于健康范围'
      },
      {
        id: 2,
        emoji: '🌙',
        iconColor: '#5856D6',
        bgColor: 'rgba(88, 86, 214, 0.1)',
        time: '昨天 07:00',
        title: '睡眠报告',
        description: '深度睡眠4小时，浅睡眠3小时，睡眠质量优秀'
      }
    ]
  },

  onTabChange(e) {
    this.setData({ activeTab: e.currentTarget.dataset.index })
  }
})
