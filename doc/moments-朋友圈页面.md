# 朋友圈页面 (moments)

## 页面路径
`pages/moments/moments`

## 页面功能
宠物社交朋友圈页面，展示宠物动态、支持点赞和评论功能。

## 文件结构
- `moments.wxml` - 页面结构
- `moments.wxss` - 页面样式
- `moments.js` - 页面逻辑
- `moments.json` - 页面配置

## 主要修改内容

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：朋友圈
- 无返回按钮（作为 TabBar 页面）
- 白色背景

### 2. 动态卡片
- 头像：使用 `/images/pet.png`
- 用户昵称和发布时间、位置
- 图片占位区域
- 动态内容文字

### 3. 互动功能
- **点赞功能**
  - 图标：`/images/Like.png`
  - 点击切换点赞状态
  - 点赞数量实时更新
  - 点赞后数字变红色

- **评论功能**
  - 图标：`/images/Comment.png`
  - 点击展开/收起评论区
  - 支持嵌套回复（层级效果）

### 4. 评论区域
- 评论列表展示
- 回复列表缩进显示
- 昵称使用蓝色（#576b95）

## 关键代码

### WXML 结构
```xml
<navigation-bar title="朋友圈" back="{{false}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <view class="content">
    <view class="moment-item" wx:for="{{moments}}" wx:key="id">
      <!-- 头部：头像、昵称、时间 -->
      <view class="moment-header">
        <image class="avatar" src="/images/pet.png"></image>
        <view class="user-info">
          <view class="nickname">{{item.nickname}}</view>
          <view class="time-location">{{item.time}} · {{item.location}}</view>
        </view>
      </view>

      <!-- 底部：点赞、评论 -->
      <view class="moment-footer">
        <view class="action-item" bindtap="onLike" data-id="{{item.id}}">
          <image class="action-icon" src="/images/Like.png"></image>
          <text class="count">{{item.likes}}</text>
        </view>
        <view class="action-item" bindtap="toggleComments" data-id="{{item.id}}">
          <image class="action-icon" src="/images/Comment.png"></image>
          <text class="count">{{item.comments.length}}</text>
        </view>
      </view>

      <!-- 评论区域 -->
      <view class="comments-section" wx:if="{{item.showComments}}">
        <view class="comment-item" wx:for="{{item.comments}}" wx:for-item="comment">
          <view class="comment-main">
            <text class="comment-nickname">{{comment.nickname}}</text>
            <text class="comment-content">{{comment.content}}</text>
          </view>
          <!-- 回复列表 -->
          <view class="reply-item" wx:for="{{comment.replies}}" wx:for-item="reply">
            <text class="reply-nickname">{{reply.nickname}}</text>
            <text class="reply-content">{{reply.content}}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</view>
```

### JS 逻辑
```javascript
Page({
  data: {
    moments: [{
      id: 1,
      nickname: '哈士奇拆迁大队',
      likes: 1200,
      liked: false,
      comments: [...],
      showComments: false
    }]
  },

  // 点赞切换
  onLike(e) {
    const id = e.currentTarget.dataset.id
    const moments = this.data.moments.map(item => {
      if (item.id === id) {
        return {
          ...item,
          liked: !item.liked,
          likes: item.liked ? item.likes - 1 : item.likes + 1
        }
      }
      return item
    })
    this.setData({ moments })
  },

  // 展开/收起评论
  toggleComments(e) {
    const id = e.currentTarget.dataset.id
    const moments = this.data.moments.map(item => {
      if (item.id === id) {
        return { ...item, showComments: !item.showComments }
      }
      return item
    })
    this.setData({ moments })
  }
})
```

### CSS 样式要点
```css
/* 使用 margin 替代 gap（Skyline 不支持 gap） */
.action-item {
  display: flex;
  align-items: center;
  margin-right: 60rpx;
}

.action-icon {
  width: 36rpx;
  height: 36rpx;
  margin-right: 12rpx;
}

/* 点赞状态 */
.action-item.liked .count {
  color: #FF6B6B;
}

/* 评论昵称蓝色 */
.comment-nickname {
  color: #576b95;
}

/* 回复缩进 */
.reply-item {
  padding-left: 24rpx;
}

/* 昵称对齐 - 固定最小宽度确保对齐 */
.comment-nickname,
.reply-nickname {
  min-width: 140rpx;
  flex-shrink: 0;
}
```

## 注意事项
- 图标文件名区分大小写：`Like.png`、`Comment.png`
- Skyline 渲染器不支持 CSS `gap` 属性，使用 `margin` 替代
- 评论区使用 `wx:if` 控制显示/隐藏
