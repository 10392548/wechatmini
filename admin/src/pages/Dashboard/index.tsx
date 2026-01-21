import { Card, Row, Col, Statistic, Table } from 'antd'
import {
  UserOutlined,
  BugOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
} from '@ant-design/icons'
import { Column } from '@ant-design/charts'
import { useEffect, useState } from 'react'
import { statsApi } from '@/api'
import type { OverviewStats, TrendData } from '@/types/api'

export default function DashboardPage() {
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState<OverviewStats>({
    userCount: 0,
    deviceCount: 0,
    onlineDeviceCount: 0,
    todayActiveCount: 0,
    todayNewUsers: 0,
  })
  const [userTrend, setUserTrend] = useState<TrendData[]>([])
  const [deviceStatus, setDeviceStatus] = useState({
    online: 0,
    offline: 0,
    lowBattery: 0,
  })

  useEffect(() => {
    loadData()
  }, [])

  const loadData = async () => {
    try {
      setLoading(true)
      const [overview, trend, device] = await Promise.all([
        statsApi.overview(),
        statsApi.userGrowth(7),
        statsApi.deviceStatus(),
      ])
      setStats(overview)
      setUserTrend(trend)
      setDeviceStatus(device)
    } finally {
      setLoading(false)
    }
  }

  const chartData = userTrend.map((item) => ({
    date: item.date.slice(5),
    count: item.count,
  }))

  return (
    <div>
      <h1>数据统计</h1>
      <Row gutter={16} style={{ marginTop: 16 }}>
        <Col span={6}>
          <Card loading={loading}>
            <Statistic
              title="总用户数"
              value={stats.userCount}
              prefix={<UserOutlined />}
              valueStyle={{ color: '#1890ff' }}
            />
          </Card>
        </Col>
        <Col span={6}>
          <Card loading={loading}>
            <Statistic
              title="总设备数"
              value={stats.deviceCount}
              prefix={<BugOutlined />}
              valueStyle={{ color: '#52c41a' }}
            />
          </Card>
        </Col>
        <Col span={6}>
          <Card loading={loading}>
            <Statistic
              title="在线设备"
              value={stats.onlineDeviceCount}
              prefix={<CheckCircleOutlined />}
              valueStyle={{ color: '#52c41a' }}
            />
          </Card>
        </Col>
        <Col span={6}>
          <Card loading={loading}>
            <Statistic
              title="今日活跃"
              value={stats.todayActiveCount}
              prefix={<ClockCircleOutlined />}
              valueStyle={{ color: '#faad14' }}
            />
          </Card>
        </Col>
      </Row>

      <Row gutter={16} style={{ marginTop: 16 }}>
        <Col span={16}>
          <Card title="近7天用户增长" loading={loading}>
            <Column
              height={300}
              data={chartData}
              xField="date"
              yField="count"
              color="#1890ff"
              columnStyle={{ radius: [4, 4, 0, 0] }}
            />
          </Card>
        </Col>
        <Col span={8}>
          <Card title="设备状态分布" loading={loading}>
            <Table
              size="small"
              pagination={false}
              dataSource={[
                { key: 'online', name: '在线', count: deviceStatus.online },
                { key: 'offline', name: '离线', count: deviceStatus.offline },
                { key: 'low', name: '低电量', count: deviceStatus.lowBattery },
              ]}
              columns={[
                { title: '状态', dataIndex: 'name', key: 'name' },
                { title: '数量', dataIndex: 'count', key: 'count' },
              ]}
            />
          </Card>
        </Col>
      </Row>
    </div>
  )
}
