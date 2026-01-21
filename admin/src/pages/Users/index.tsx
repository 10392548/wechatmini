import { Card, Table, Button, Input, Modal, Tag, Space } from 'antd'
import { SearchOutlined, StopOutlined, UnlockOutlined } from '@ant-design/icons'
import { useEffect, useState } from 'react'
import type { ColumnsType } from 'antd/es/table'
import { userApi } from '@/api'
import type { User } from '@/types/api'

export default function UserListPage() {
  const [loading, setLoading] = useState(false)
  const [dataSource, setDataSource] = useState<User[]>([])
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 })
  const [keyword, setKeyword] = useState('')

  useEffect(() => {
    loadData()
  }, [pagination.current, pagination.pageSize])

  const loadData = async () => {
    try {
      setLoading(true)
      const data = await userApi.getList({
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

  const handleBan = (user: User) => {
    Modal.confirm({
      title: '确认封禁',
      content: `确定要封禁用户 "${user.nickname}" 吗？`,
      onOk: async () => {
        await userApi.ban(user.id, '违反社区规范')
        loadData()
      },
    })
  }

  const handleUnban = async (user: User) => {
    await userApi.unban(user.id)
    loadData()
  }

  const columns: ColumnsType<User> = [
    {
      title: 'ID',
      dataIndex: 'id',
      width: 80,
    },
    {
      title: '头像',
      dataIndex: 'avatar',
      width: 60,
      render: (avatar: string) => (
        <img
          src={avatar || '/vite.svg'}
          alt="avatar"
          style={{ width: 32, height: 32, borderRadius: '50%' }}
        />
      ),
    },
    {
      title: '昵称',
      dataIndex: 'nickname',
      width: 150,
    },
    {
      title: '手机号',
      dataIndex: 'phone',
      width: 120,
      render: (phone: string) => phone || '-',
    },
    {
      title: '状态',
      dataIndex: 'is_banned',
      width: 80,
      render: (isBanned: boolean) =>
        isBanned ? (
          <Tag color="red">已封禁</Tag>
        ) : (
          <Tag color="green">正常</Tag>
        ),
    },
    {
      title: '宠物数',
      dataIndex: 'pets',
      width: 80,
      render: (pets: any[]) => pets?.length || 0,
    },
    {
      title: '注册时间',
      dataIndex: 'created_at',
      width: 180,
      render: (date: string) => new Date(date).toLocaleString('zh-CN'),
    },
    {
      title: '操作',
      key: 'action',
      width: 150,
      fixed: 'right',
      render: (_: any, user: User) => (
        <Space>
          {user.is_banned ? (
            <Button
              type="link"
              size="small"
              icon={<UnlockOutlined />}
              onClick={() => handleUnban(user)}
            >
              解封
            </Button>
          ) : (
            <Button
              type="link"
              size="small"
              danger
              icon={<StopOutlined />}
              onClick={() => handleBan(user)}
            >
              封禁
            </Button>
          )}
        </Space>
      ),
    },
  ]

  return (
    <div>
      <Card title="用户管理" extra={
        <Space>
          <Input
            placeholder="搜索用户"
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
          scroll={{ x: 800 }}
        />
      </Card>
    </div>
  )
}
