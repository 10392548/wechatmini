// 文件日志工具
const fs = wx.getFileSystemManager()
let logPath = `${wx.env.USER_DATA_PATH}/debug.log`

// 检查路径是否有效（开发者工具可能返回无效路径如 http://usr）
const isPathValid = logPath && !logPath.startsWith('http') && !logPath.includes('://')

function writeLog(message) {
  // 输出到控制台
  console.log(message)

  // 只在路径有效时尝试写入文件
  if (!isPathValid) {
    return
  }

  try {
    const timestamp = new Date().toISOString()
    const logMessage = `[${timestamp}] ${message}\n`
    fs.appendFileSync(logPath, logMessage, 'utf8')
  } catch (error) {
    // 静默处理文件写入失败
  }
}

function clearLog() {
  try {
    fs.writeFileSync(logPath, '', 'utf8')
    console.log('[文件日志] 日志已清空')
  } catch (error) {
    console.error('[文件日志] 清空失败:', error)
  }
}

function readLog() {
  try {
    const content = fs.readFileSync(logPath, 'utf8')
    return content
  } catch (error) {
    console.error('[文件日志] 读取失败:', error)
    return ''
  }
}

module.exports = {
  log: writeLog,
  clear: clearLog,
  read: readLog,
  path: logPath
}
