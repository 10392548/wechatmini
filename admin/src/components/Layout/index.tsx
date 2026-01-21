import { Layout, Menu, Dropdown, Avatar, Button } from 'antd'
import { Outlet, useNavigate, useLocation } from 'react-router-dom'
import {
  HomeOutlined,
  UserOutlined,
  BugOutlined,
  MessageOutlined,
  LineChartOutlined,
  CloudOutlined,
  SettingOutlined,
  LogoutOutlined,
} from '@ant-design/icons'
import { useAuthStore } from '@/stores/auth'
import './index.css'

const { Header, Sider, Content } = Layout

const menuItems = [
  { key: '/dashboard', icon: <HomeOutlined />, label: '数据统计' },
  { key: '/users', icon: <UserOutlined />, label: '用户管理' },
  { key: '/devices', icon: <BugOutlined />, label: '设备管理' },
  { key: '/moments', icon: <MessageOutlined />, label: '内容审核' },
  { key: '/mqtt', icon: <CloudOutlined />, label: 'MQTT监控' },
  { key: '/settings', icon: <SettingOutlined />, label: '系统配置' },
]

export default function LayoutPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const logout = useAuthStore((state) => state.logout)
  const adminInfo = useAuthStore((state) => state.adminInfo)

  const handleMenuClick = ({ key }: { key: string }) => {
    navigate(key)
  }

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  const userMenuItems = [
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: '退出登录',
      onClick: handleLogout,
    },
  ]

  return (
    <Layout className="layout-container">
      <Sider width={240} theme="light" className="layout-sider">
        <div className="layout-logo">
          <img src="/vite.svg" alt="logo" />
          <span>宠物项圈管理</span>
        </div>
        <Menu
          mode="inline"
          selectedKeys={[location.pathname]}
          items={menuItems}
          onClick={handleMenuClick}
        />
      </Sider>
      <Layout>
        <Header className="layout-header">
          <div className="header-left">
            <h2>管理后台</h2>
          </div>
          <div className="header-right">
            <Dropdown menu={{ items: userMenuItems }} placement="bottomRight">
              <div className="user-info">
                <Avatar icon={<UserOutlined />} />
                <span className="username">{adminInfo?.username || '管理员'}</span>
              </div>
            </Dropdown>
          </div>
        </Header>
        <Content className="layout-content">
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}
