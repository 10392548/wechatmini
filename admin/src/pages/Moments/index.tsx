import { Card, Table, Button, Image, Space, Modal, Tag } from 'antd'
import { DeleteOutlined, EyeOutlined } from '@ant-design/icons'
import { useEffect, useState } from 'react'
import type { ColumnsType } from 'antd/es/table'
import { momentApi } from '@/api'
import type { Moment } from '@/types/api'

export default function MomentListPage() {
  const [loading, setLoading] = useState(false)
  const [dataSource, setDataSource] = useState<Moment[]>([])
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 })
  const [previewVisible, setPreviewVisible] = useState(false)
  const [previewImage, setPreviewImage] = useState('')

  useEffect(() => {
    loadData()
  }, [pagination.current, pagination.pageSize])

  const loadData = async () => {
    try {
      setLoading(true)
      const data = await momentApi.getList({
        page: pagination.current,
        pageSize: pagination.pageSize,
      })
      setDataSource(data.list)
      setPagination((prev) => ({ ...prev, total: data.total }))
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = (moment: Moment) => {
    Modal.confirm({
      title: '确认删除',
      content: `确定要删除这条朋友圈吗？\n内容: ${moment.content}`,
      onOk: async () => {
        await momentApi.delete(moment.id)
        loadData()
      },
    })
  }

  const handlePreview = (url: string) => {
    setPreviewImage(url)
    setPreviewVisible(true)
  }

  const columns: ColumnsType<Moment> = [
    {
      title: 'ID',
      dataIndex: 'id',
      width: 80,
    },
    {
      title: '用户',
      dataIndex: 'user',
      width: 120,
      render: (user: any) => user?.nickname || '-',
    },
    {
      title: '宠物',
      dataIndex: 'pet',
      width: 100,
      render: (pet: any) => pet?.name || '-',
    },
    {
      title: '内容',
      dataIndex: 'content',
      width: 200,
      ellipsis: true,
    },
    {
      title: '图片',
      dataIndex: 'images',
      width: 150,
      render: (images: string[]) =>
        images?.length > 0 ? (
          <Image.PreviewGroup>
            {images.slice(0, 3).map((url, index) => (
              <Image
                key={index}
                src={url}
                width={40}
                height={40}
                style={{ marginRight: 4 }}
              />
            ))}
          </Image.PreviewGroup>
        ) : null,
    },
    {
      title: '互动',
      key: 'interaction',
      width: 120,
      render: (_: any, record: Moment) => (
        <Space>
          <Tag color="red">❤️ {record.likeCount}</Tag>
          <Tag color="blue">💬 {record.commentCount}</Tag>
        </Space>
      ),
    },
    {
      title: '发布时间',
      dataIndex: 'created_at',
      width: 180,
      render: (date: string) => new Date(date).toLocaleString('zh-CN'),
    },
    {
      title: '操作',
      key: 'action',
      width: 100,
      fixed: 'right',
      render: (_: any, moment: Moment) => (
        <Space>
          <Button
            type="link"
            size="small"
            danger
            icon={<DeleteOutlined />}
            onClick={() => handleDelete(moment)}
          >
            删除
          </Button>
        </Space>
      ),
    },
  ]

  return (
    <div>
      <Card title="内容审核">
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
          scroll={{ x: 900 }}
        />
      </Card>
      <Image
        preview={{ visible: previewVisible, onVisibleChange: (vis) => setPreviewVisible(vis) }}
        src={previewImage}
        style={{ display: 'none' }}
      />
    </div>
  )
}
