import { Card, Table, Button, Input, Tag, Space, Badge, Switch, Modal } from 'antd'
import { SearchOutlined, ThunderboltOutlined, BulbOutlined, MoonOutlined } from '@ant-design/icons'
import { useEffect, useState } from 'react'
import type { ColumnsType } from 'antd/es/table'
import { deviceApi } from '@/api'
import type { Device } from '@/types/api'

export default function DeviceListPage() {
  const [loading, setLoading] = useState(false)
  const [dataSource, setDataSource] = useState<Device[]>([])
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 })
  const [keyword, setKeyword] = useState('')

  useEffect(() => {
    loadData()
  }, [pagination.current, pagination.pageSize])

  const loadData = async () => {
    try {
      setLoading(true)
      const data = await deviceApi.getList({
        page: pagination.current,
        pageSize: pagination.pageSize,
        keyword,
      })
      setDataSource(data.list)
      setPagination((prev) => ({ ...prev, total: data.total }))
    } finally {
      setLoading(false)
    }
  }

  const handleSearch = () => {
    setPagination((prev) => ({ ...prev, current: 1 }))
    loadData()
  }

  const handleControl = async (device: Device, type: 'buzzer' | 'led' | 'sleep', enabled: boolean) => {
    Modal.confirm({
      title: '确认操作',
      content: `确定要${enabled ? '开启' : '关闭'} ${type === 'buzzer' ? '蜂鸣器' : type === 'led' ? 'LED灯' : '休眠模式'} 吗？`,
      onOk: async () => {
        try {
          if (type === 'buzzer') {
            await deviceApi.buzzerControl(device.id, enabled)
          } else if (type === 'led') {
            await deviceApi.ledControl(device.id, enabled)
          } else {
            await deviceApi.sleepControl(device.id, enabled)
          }
          loadData()
        } catch (error) {
          // 错误已在 request.ts 中处理
        }
      },
    })
  }

  const columns: ColumnsType<Device> = [
    {
      title: 'ID',
      dataIndex: 'id',
      width: 80,
    },
    {
      title: '设备SN',
      dataIndex: 'deviceSn',
      width: 200,
    },
    {
      title: '状态',
      dataIndex: 'isOnline',
      width: 100,
      render: (isOnline: boolean) =>
        isOnline ? (
          <Badge status="success" text="在线" />
        ) : (
          <Badge status="default" text="离线" />
        ),
    },
    {
      title: '电量',
      dataIndex: 'batteryLevel',
      width: 100,
      render: (level: number) => (
        <Tag color={level > 50 ? 'green' : level > 20 ? 'orange' : 'red'}>
          {level}%
        </Tag>
      ),
    },
    {
      title: '绑定宠物',
      dataIndex: 'pet',
      width: 120,
      render: (pet: any) => pet?.name || '-',
    },
    {
      title: '蜂鸣器',
      dataIndex: 'buzzerEnabled',
      width: 100,
      render: (enabled: boolean, record: Device) => (
        <Switch
          checked={enabled}
          onChange={(val) => handleControl(record, 'buzzer', val)}
          disabled={!record.isOnline}
        />
      ),
    },
    {
      title: 'LED',
      dataIndex: 'ledEnabled',
      width: 80,
      render: (enabled: boolean, record: Device) => (
        <Switch
          checked={enabled}
          onChange={(val) => handleControl(record, 'led', val)}
          disabled={!record.isOnline}
        />
      ),
    },
    {
      title: '休眠模式',
      dataIndex: 'sleepModeEnabled',
      width: 100,
      render: (enabled: boolean, record: Device) => (
        <Switch
          checked={enabled}
          onChange={(val) => handleControl(record, 'sleep', val)}
          disabled={!record.isOnline}
        />
      ),
    },
    {
      title: '最后在线',
      dataIndex: 'lastOnlineAt',
      width: 180,
      render: (date: string) => date ? new Date(date).toLocaleString('zh-CN') : '-',
    },
  ]

  return (
    <div>
      <Card title="设备管理" extra={
        <Space>
          <Input
            placeholder="搜索设备SN"
            prefix={<SearchOutlined />}
            style={{ width: 200 }}
            value={keyword}
            onChange={(e) => setKeyword(e.target.value)}
            onPressEnter={handleSearch}
          />
          <Button type="primary" onClick={handleSearch}>
            搜索
          </Button>
        </Space>
      }>
        <Table
          rowKey="id"
          loading={loading}
          columns={columns}
          dataSource={dataSource}
          pagination={{
            current: pagination.current,
            pageSize: pagination.pageSize,
            total: pagination.total,
            showSizeChanger: true,
            showTotal: (t) => `共 ${t} 条`,
            onChange: (page, pageSize) =>
              setPagination({ current: page, pageSize: pageSize || 10, total: pagination.total }),
          }}
          scroll={{ x: 1000 }}
        />
      </Card>
    </div>
  )
}
