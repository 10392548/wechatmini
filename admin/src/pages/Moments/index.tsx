import { Card, Table, Button, Image, Space, Modal, Tag, Select, Input, message } from 'antd'
import { DeleteOutlined, CheckOutlined, CloseOutlined } from '@ant-design/icons'
import { useEffect, useState } from 'react'
import type { ColumnsType, TableProps } from 'antd/es/table'
import { momentApi } from '@/api'
import type { Moment } from '@/types/api'

const { TextArea } = Input

export default function MomentListPage() {
  const [loading, setLoading] = useState(false)
  const [dataSource, setDataSource] = useState<Moment[]>([])
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 })
  const [previewVisible, setPreviewVisible] = useState(false)
  const [previewImage, setPreviewImage] = useState('')
  const [statusFilter, setStatusFilter] = useState<string | undefined>()
  const [rejectModalVisible, setRejectModalVisible] = useState(false)
  const [rejectingMoment, setRejectingMoment] = useState<Moment | null>(null)
  const [rejectReason, setRejectReason] = useState('')

  useEffect(() => {
    loadData()
  }, [pagination.current, pagination.pageSize, statusFilter])

  const loadData = async () => {
    try {
      setLoading(true)
      const data = await momentApi.getList({
        page: pagination.current,
        pageSize: pagination.pageSize,
        status: statusFilter,
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
        message.success('删除成功')
        loadData()
      },
    })
  }

  const handleApprove = async (moment: Moment) => {
    try {
      await momentApi.approve(moment.id)
      message.success('审核通过')
      loadData()
    } catch {
      message.error('操作失败')
    }
  }

  const handleReject = (moment: Moment) => {
    setRejectingMoment(moment)
    setRejectReason('')
    setRejectModalVisible(true)
  }

  const handleRejectSubmit = async () => {
    if (!rejectingMoment) return

    try {
      await momentApi.reject(rejectingMoment.id, rejectReason)
      message.success('已驳回')
      setRejectModalVisible(false)
      loadData()
    } catch {
      message.error('操作失败')
    }
  }

  const handlePreview = (url: string) => {
    setPreviewImage(url)
    setPreviewVisible(true)
  }

  const getStatusTag = (status?: string) => {
    switch (status) {
      case 'pending':
        return <Tag color="orange">待审核</Tag>
      case 'approved':
        return <Tag color="green">已通过</Tag>
      case 'rejected':
        return <Tag color="red">已驳回</Tag>
      default:
        return <Tag>{status || '未知'}</Tag>
    }
  }

  const onTableChange: TableProps<Moment>['onChange'] = (pagination, filters) => {
    if (filters.status && filters.status.length > 0) {
      setStatusFilter(filters.status[0] as string)
    } else {
      setStatusFilter(undefined)
    }
  }

  const columns: ColumnsType<Moment> = [
    {
      title: 'ID',
      dataIndex: 'id',
      width: 70,
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 90,
      render: (status) => getStatusTag(status),
      filters: [
        { text: '待审核', value: 'pending' },
        { text: '已通过', value: 'approved' },
        { text: '已驳回', value: 'rejected' },
      ],
    },
    {
      title: '用户',
      dataIndex: 'user',
      width: 110,
      render: (user: any) => user?.nickname || '-',
    },
    {
      title: '宠物',
      dataIndex: 'pet',
      width: 90,
      render: (pet: any) => pet?.name || '-',
    },
    {
      title: '内容',
      dataIndex: 'content',
      width: 180,
      ellipsis: true,
    },
    {
      title: '图片',
      dataIndex: 'images',
      width: 140,
      render: (images: string[]) =>
        images?.length > 0 ? (
          <Image.PreviewGroup>
            {images.slice(0, 3).map((url, index) => (
              <Image
                key={index}
                src={url}
                width={36}
                height={36}
                style={{ marginRight: 4, objectFit: 'cover' }}
              />
            ))}
          </Image.PreviewGroup>
        ) : null,
    },
    {
      title: '互动',
      key: 'interaction',
      width: 100,
      render: (_: any, record: Moment) => (
        <Space size={4}>
          <Tag color="red">{record.likeCount}赞</Tag>
          <Tag color="blue">{record.commentCount}评</Tag>
        </Space>
      ),
    },
    {
      title: '审核时间',
      dataIndex: 'reviewed_at',
      width: 160,
      render: (date: string) => (date ? new Date(date).toLocaleString('zh-CN') : '-'),
    },
    {
      title: '驳回原因',
      dataIndex: 'rejection_reason',
      width: 160,
      ellipsis: true,
      render: (reason) => reason || '-',
    },
    {
      title: '发布时间',
      dataIndex: 'created_at',
      width: 160,
      render: (date: string) => new Date(date).toLocaleString('zh-CN'),
    },
    {
      title: '操作',
      key: 'action',
      width: 240,
      fixed: 'right',
      render: (_: any, moment: Moment) => (
        <Space size={4}>
          {moment.status === 'pending' && (
            <>
              <Button
                type="link"
                size="small"
                icon={<CheckOutlined />}
                onClick={() => handleApprove(moment)}
              >
                通过
              </Button>
              <Button
                type="link"
                size="small"
                danger
                icon={<CloseOutlined />}
                onClick={() => handleReject(moment)}
              >
                驳回
              </Button>
            </>
          )}
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
      <Card
        title="内容审核"
        extra={
          <Space>
            <span>状态筛选:</span>
            <Select
              placeholder="全部"
              allowClear
              style={{ width: 120 }}
              value={statusFilter}
              onChange={(value) => {
                setStatusFilter(value)
                setPagination((prev) => ({ ...prev, current: 1 }))
              }}
            >
              <Select.Option value="pending">待审核</Select.Option>
              <Select.Option value="approved">已通过</Select.Option>
              <Select.Option value="rejected">已驳回</Select.Option>
            </Select>
          </Space>
        }
      >
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
          scroll={{ x: 1400 }}
          onChange={onTableChange}
        />
      </Card>
      <Image
        preview={{ visible: previewVisible, onVisibleChange: (vis) => setPreviewVisible(vis) }}
        src={previewImage}
        style={{ display: 'none' }}
      />
      <Modal
        title="审核驳回"
        open={rejectModalVisible}
        onOk={handleRejectSubmit}
        onCancel={() => setRejectModalVisible(false)}
        okText="确认驳回"
        cancelText="取消"
        okButtonProps={{ danger: true }}
      >
        <div style={{ marginBottom: 16 }}>
          <p style={{ margin: 0 }}>
            <strong>内容:</strong> {rejectingMoment?.content || '(无文字内容)'}
          </p>
        </div>
        <div>
          <p style={{ marginBottom: 8, fontWeight: 500 }}>驳回原因（可选）:</p>
          <TextArea
            rows={4}
            value={rejectReason}
            onChange={(e) => setRejectReason(e.target.value)}
            placeholder="请输入驳回原因，如：内容违规、含有敏感信息等"
          />
        </div>
      </Modal>
    </div>
  )
}
