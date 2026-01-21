import { Form, Input, Button, Card, message } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import { useNavigate } from 'react-router-dom'
import { useAuthStore } from '@/stores/auth'
import { authApi } from '@/api'
import type { LoginRequest } from '@/types/api'
import './index.css'

export default function LoginPage() {
  const navigate = useNavigate()
  const login = useAuthStore((state) => state.login)
  const [form] = Form.useForm()

  const onFinish = async (values: LoginRequest) => {
    try {
      const data = await authApi.login(values)
      login(data.token, data.admin)
      message.success('登录成功')
      navigate('/dashboard')
    } catch (error) {
      // 错误已在 request.ts 中处理
    }
  }

  return (
    <div className="login-container">
      <Card className="login-card" title="宠物项圈管理后台" bordered={false}>
        <Form
          form={form}
          name="login"
          initialValues={{ username: '', password: '' }}
          onFinish={onFinish}
          size="large"
        >
          <Form.Item
            name="username"
            rules={[{ required: true, message: '请输入用户名' }]}
          >
            <Input
              prefix={<UserOutlined />}
              placeholder="用户名"
            />
          </Form.Item>
          <Form.Item
            name="password"
            rules={[{ required: true, message: '请输入密码' }]}
          >
            <Input.Password
              prefix={<LockOutlined />}
              placeholder="密码"
            />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              登录
            </Button>
          </Form.Item>
        </Form>
        <div className="login-tips">
          默认账号: admin / admin123
        </div>
      </Card>
    </div>
  )
}
