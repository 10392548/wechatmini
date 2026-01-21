import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { ConfigProvider, theme } from 'antd'
import zhCN from 'antd/locale/zh_CN'
import ProtectedRoute from '@/components/ProtectedRoute'
import LayoutPage from '@/components/Layout'
import LoginPage from '@/pages/Login'
import DashboardPage from '@/pages/Dashboard'
import UserList from '@/pages/Users'
import DeviceList from '@/pages/Devices'
import MomentList from '@/pages/Moments'
import MqttMonitor from '@/pages/MQTT'
import SettingsPage from '@/pages/Settings'
import 'antd/dist/reset.css'
import './App.css'

function App() {
  return (
    <ConfigProvider
      locale={zhCN}
      theme={{
        algorithm: theme.defaultAlgorithm,
        token: {
          colorPrimary: '#1890ff',
        },
      }}
    >
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <LayoutPage />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route path="dashboard" element={<DashboardPage />} />
            <Route path="users" element={<UserList />} />
            <Route path="devices" element={<DeviceList />} />
            <Route path="moments" element={<MomentList />} />
            <Route path="mqtt" element={<MqttMonitor />} />
            <Route path="settings" element={<SettingsPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </ConfigProvider>
  )
}

export default App
