import { Card, Form, Input, Button, Switch, Space, message } from 'antd'
import { useEffect, useState } from 'react'
import { systemApi } from '@/api'

interface ConfigItem {
  key: string
  value: any
  description: string
}

export default function SettingsPage() {
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [configs, setConfigs] = useState<ConfigItem[]>([])
  const [form] = Form.useForm()

  useEffect(() => {
    loadConfigs()
  }, [])

  const loadConfigs = async () => {
    try {
      setLoading(true)
      const data = await systemApi.getSettings()
      setConfigs(data)
      const formData: Record<string, any> = {}
      data.forEach((item) => {
        formData[item.key] = item.value
      })
      form.setFieldsValue(formData)
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async (values: Record<string, any>) => {
    try {
      setSaving(true)
      await systemApi.updateSettings(values)
      message.success('保存成功')
      loadConfigs()
    } finally {
      setSaving(false)
    }
  }

  return (
    <div>
      <Card title="系统配置" loading={loading}>
        <Form
          form={form}
          layout="vertical"
          onFinish={handleSave}
        >
          <Form.Item
            label="最大用户数"
            name="maxUsers"
            help="系统支持的最大用户数量"
          >
            <Input type="number" placeholder="请输入最大用户数" />
          </Form.Item>

          <Form.Item
            label="设备超时时间（秒）"
            name="deviceTimeout"
            help="设备离线超时时间，超过此时间将被标记为离线"
          >
            <Input type="number" placeholder="请输入超时时间" />
          </Form.Item>

          <Form.Item
            label="低电量阈值（%）"
            name="lowBatteryThreshold"
            help="设备电量低于此值时显示低电量警告"
          >
            <Input type="number" placeholder="请输入阈值" />
          </Form.Item>

          <Form.Item
            label="MQTT Broker 地址"
            name="mqttBroker"
            help="MQTT 消息服务器地址"
          >
            <Input placeholder="请输入 MQTT Broker 地址" />
          </Form.Item>

          <Form.Item
            label="启用内容审核"
            name="contentModerationEnabled"
            valuePropName="checked"
            help="开启后用户发布的内容需要经过审核"
          >
            <Switch />
          </Form.Item>

          <Form.Item
            label="启用设备自动注册"
            name="autoRegisterEnabled"
            valuePropName="checked"
            help="开启后新设备首次连接将自动注册"
          >
            <Switch />
          </Form.Item>

          <Form.Item>
            <Space>
              <Button type="primary" htmlType="submit" loading={saving}>
                保存配置
              </Button>
              <Button onClick={loadConfigs}>
                重置
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Card>
    </div>
  )
}
