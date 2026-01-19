# AI聊天页面 (chat)

## 页面路径
`pages/chat/chat`

## 页面功能
人与宠物AI的对话页面,主人可以与宠物豆包进行实时聊天交流。

## 文件结构
- `chat.wxml` - 页面结构
- `chat.wxss` - 页面样式
- `chat.js` - 页面逻辑
- `chat.json` - 页面配置

## 主要功能

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：AI聊天
- 无返回按钮（作为 TabBar 页面）
- 白色背景

### 2. 头部区域
- 宠物头像（emoji 🐕）
- 宠物名称：豆包（AI 宠物）
- 在线状态显示：在线中·在家开心

### 3. 聊天区域
- 消息列表展示
- 支持两种消息类型：
  - `user`: 主人发送的消息（右侧显示，橙色气泡）
  - `pet`: 宠物发送的消息（左侧显示，白色气泡）
- 每条消息显示：
  - 头像（主人 👤 / 宠物 🐕）
  - 发送者名称（主人 / 豆包）
  - 消息内容
  - 发送时间
- 消息气泡样式区分

### 4. 输入区域
- 输入框：给豆包留言...
- 发送按钮（橙色圆形按钮）
- 发送后自动模拟宠物回复

## 关键代码

### JS 数据结构
```javascript
data: {
  messages: [
    {
      type: 'pet',
      sender: '豆包',
      content: '主人！我现在感觉非常兴奋！...',
      time: '10:30'
    },
    {
      type: 'user',
      sender: '主人',
      content: '豆包真棒，中午想吃什么？',
      time: '10:31'
    }
  ]
}
```

### 发送消息逻辑
```javascript
sendMessage() {
  const newMessage = {
    type: 'user',
    sender: '主人',
    content: this.data.inputText,
    time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  };

  // 添加用户消息
  this.setData({
    messages: [...this.data.messages, newMessage],
    inputText: ''
  });

  // 1秒后模拟宠物回复
  setTimeout(() => {
    const petReply = {
      type: 'pet',
      sender: '豆包',
      content: '汪汪！收到啦~',
      time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    };
    this.setData({
      messages: [...this.data.messages, petReply]
    });
  }, 1000);
}
```

## TabBar 配置
- 已添加到底部 TabBar
- 图标：`/images/chat.png`
- 位置：第2个标签

## 样式特点
- 白色背景风格
- 主人消息：右侧显示，橙色渐变气泡，白色文字
- 宠物消息：左侧显示，白色气泡，黑色文字
- 每条消息带头像和发送者名称
- 底部固定输入栏
- 隐藏滚动条

## 最近更新
- 修改消息显示方式,明确显示人和宠物的对话
- 添加消息头像(主人 👤 / 宠物 🐕)
- 添加发送者名称显示(主人 / 豆包)
- 添加消息时间显示
- 修复消息类型逻辑(user = 主人, pet = 宠物)
- 添加自动回复功能(发送消息后1秒宠物自动回复)
- 改为 TabBar 页面
