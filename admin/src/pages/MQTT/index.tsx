import { Card, Row, Col, Statistic, Table, Tag } from 'antd'
import { CloudServerOutlined, MessageOutlined, CheckCircleOutlined } from '@ant-design/icons'
import { useEffect, useState } from 'react'
import type { ColumnsType } from 'antd/es/table'
import { mqttApi } from '@/api'
import type { MqttStats, DeviceLog } from '@/types/api'

export default function MqttMonitorPage() {
  const [loading, setLoading] = useState(false)
  const [stats, setStats] = useState<MqttStats>({
    messagesReceived: 0,
    messagesSent: 0,
    activeDevices: 0,
  })
  const [logs, setLogs] = useState<DeviceLog[]>([])
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 })

  useEffect(() => {
    loadStats()
    loadLogs()
  }, [pagination.current, pagination.pageSize])

  const loadStats = async () => {
    try {
      const data = await mqttApi.stats()
      setStats(data)
    } catch (error) {
      // 静默处理
    }
  }

  const loadLogs = async () => {
    try {
      setLoading(true)
      const data = await mqttApi.logs({
        page: pagination.current,
        pageSize: pagination.pageSize,
      })
      setLogs(data.list)
      setPagination((prev) => ({ ...prev, total: data.total }))
    } finally {
      setLoading(false)
    }
  }

  const logColumns: ColumnsType<DeviceLog> = [
    {
      title: '时间',
      dataIndex: 'timestamp',
      width: 180,
      render: (date: string) => new Date(date).toLocaleString('zh-CN'),
    },
    {
      title: '设备SN',
      dataIndex: 'deviceSn',
      width: 200,
    },
    {
      title: '类型',
      dataIndex: 'type',
      width: 120,
      render: (type: string) => {
        const colorMap: Record<string, string> = {
          data: 'blue',
          command: 'orange',
          status: 'green',
          error: 'red',
        }
        return <Tag color={colorMap[type] || 'default'}>{type}</Tag>
      },
    },
    {
      title: '消息',
      dataIndex: 'message',
      ellipsis: true,
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 100,
      render: (status: string) => {
        const colorMap: Record<string, string> = {
          success: 'green',
          failed: 'red',
          pending: 'orange',
        }
        return <Tag color={colorMap[status] || 'default'}>{status}</Tag>
      },
    },
  ]

  return (
    <div>
      <h1>MQTT 监控</h1>
      <Row gutter={16} style={{ marginTop: 16 }}>
        <Col span={8}>
          <Card>
            <Statistic
              title="接收消息"
              value={stats.messagesReceived}
              prefix={<MessageOutlined />}
              valueStyle={{ color: '#1890ff' }}
            />
          </Card>
        </Col>
        <Col span={8}>
          <Card>
            <Statistic
              title="发送消息"
              value={stats.messagesSent}
              prefix={<CloudServerOutlined />}
              valueStyle={{ color: '#52c41a' }}
            />
          </Card>
        </Col>
        <Col span={8}>
          <Card>
            <Statistic
              title="活跃设备"
              value={stats.activeDevices}
              prefix={<CheckCircleOutlined />}
              valueStyle={{ color: '#faad14' }}
            />
          </Card>
        </Col>
      </Row>

      <Card title="消息日志" style={{ marginTop: 16 }}>
        <Table
          rowKey="timestamp"
          loading={loading}
          columns={logColumns}
          dataSource={logs}
          pagination={{
            current: pagination.current,
            pageSize: pagination.pageSize,
            total: pagination.total,
            showSizeChanger: true,
            showTotal: (t) => `共 ${t} 条`,
            onChange: (page, pageSize) =>
              setPagination({ current: page, pageSize: pageSize || 10, total: pagination.total }),
          }}
        />
      </Card>
    </div>
  )
}
