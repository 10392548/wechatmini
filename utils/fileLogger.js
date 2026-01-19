// 文件日志工具
const fs = wx.getFileSystemManager()
const logPath = `${wx.env.USER_DATA_PATH}/debug.log`

function writeLog(message) {
  try {
    const timestamp = new Date().toISOString()
    const logMessage = `[${timestamp}] ${message}\n`

    // 追加写入日志
    fs.appendFileSync(logPath, logMessage, 'utf8')

    // 同时输出到控制台
    console.log(message)
  } catch (error) {
    console.error('[文件日志] 写入失败:', error)
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
