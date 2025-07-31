# Astral3d-editor-with-rocksi 项目使用与开发指南

---

## 目录

*   [1. 项目介绍与架构](#1-项目介绍与架构)
*   [2. 环境准备与配置](#2-环境准备与配置)
    *   [2.1. 环境依赖安装](#21-环境依赖安装)
        *   [2.1.1. 操作系统](#211-操作系统)
        *   [2.1.2. 安装 Go](#212-安装-go-推荐-120及以上)
        *   [2.1.3. 安装 Node.js](#213-安装-nodejs-推荐-16x或18x)
        *   [2.1.4. 安装 MySQL](#214-安装-mysql)
    *   [2.2. 项目数据库配置指南 (MySQL)](#22-项目数据库配置指南-mysql)
        *   [2.2.1. 登录 MySQL 控制台](#221-登录-mysql-控制台)
        *   [2.2.2. 创建数据库与用户](#222-创建数据库与用户-推荐配置)
        *   [2.2.3. 导入数据库结构](#223-导入数据库结构-初始表)
*   [3. 代码与配置](#3-代码与配置)
    *   [3.1. 代码获取与目录结构](#31-代码获取与目录结构)
    *   [3.2. 关键配置文件说明](#32-关键配置文件说明)
        *   [3.2.1. 后端数据库连接](#321-后端数据库连接-astral3deditorgobackconfappconf)
        *   [3.2.2. 前端环境变量](#322-前端环境变量-astral3deditor-env)
        *   [3.2.3. 前端开发环境变量](#323-前端开发环境变量-astral3deditor-envdevelopment)
*   [4. 启动与验证](#4-启动与验证)
    *   [4.1. 启动步骤](#41-启动步骤)
        *   [4.1.1. 启动 MySQL 服务](#411-启动-mysql-服务)
        *   [4.1.2. 启动后端服务](#412-启动后端服务)
        *   [4.1.3. 启动前端服务](#413-启动前端服务)
        *   [4.1.4. 启动 Rocksi](#414-启动-rocksi-用于集成开发)
        *   [4.1.5. 一键启动脚本](#415-一键启动脚本)
    *   [4.2. 运行成功表现](#42-运行成功表现)
*   [5. 开发与扩展指南](#5-开发与扩展指南)
    *   [5.1. 开发一：如何添加一个自定义 Blockly Block](#51-开发一如何添加一个自定义-blockly-block以-suspend-为例)
    *   [5.2. 开发二：多机器人模型选择支持说明](#52-开发二多机器人模型选择支持说明-robot-selector-support)
*   [6. 其他信息](#6-其他信息)
    *   [6.1. 常见问题与解决方案 (FAQ)](#61-常见问题与解决方案-faq)
    *   [6.2. 版本兼容性与注意事项](#62-版本兼容性与注意事项)

---

## 1. 项目介绍与架构

**Astral3d-editor-with-rocksi** 是一个集成了前端3D编辑器（基于Rocksi卡片式编程）和后端Go服务的Web应用。

*   **前端**：Vue + Vite + Unocss，提供3D编辑界面。
*   **后端**：Go (Beego框架)，负责业务逻辑和数据库操作。
*   **数据库**：MySQL，存储场景数据等。

**架构图示：**

```text
用户浏览器 <---> 前端 (Vue + Vite) <---> 后端 (Go Beego) <---> MySQL数据库
```

---

## 2. 环境准备与配置

### 2.1. 环境依赖安装

#### 2.1.1. 操作系统
推荐 Ubuntu 22.04 或等效 Linux。

#### 2.1.2. 安装 Go (推荐 1.20及以上)
```bash
wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
```

#### 2.1.3. 安装 Node.js (推荐 16.x或18.x)
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v
```

#### 2.1.4. 安装 MySQL
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 2.2. 项目数据库配置指南 (MySQL)

本指南适用于后端使用 Beego 框架 + MySQL 的项目部署环境。

#### 2.2.1. 登录 MySQL 控制台
```bash
mysql -u root -p
```

#### 2.2.2. 创建数据库与用户 (推荐配置)
在 MySQL 控制台中依次执行以下命令（直接整体复制粘贴就行）：
```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS astral3d
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 删除旧用户（如存在）
DROP USER IF EXISTS 'astral'@'localhost';
DROP USER IF EXISTS 'astral'@'127.0.0.1';

-- 创建新用户（推荐强密码）
CREATE USER 'astral'@'localhost' IDENTIFIED BY 'Astral@2025!';

-- 授权访问
GRANT ALL PRIVILEGES ON astral3d.* TO 'astral'@'localhost';

-- 应用权限
FLUSH PRIVILEGES;
```

### 2.2.3. 导入数据库结构 (初始表)
确保你有初始化 SQL 文件位于 `static/sql/astral-3d-editor.sql`。在 `Astral3DEditorGoBack` 目录下运行：

```bash
mysql -uastral -pAstral@2025! astral3d < static/sql/astral-3d-editor.sql
```
> ✅ 成功导入后，可在数据库中查看表结构和初始数据是否正确。

---

## 3. 代码与配置

### 3.1. 代码获取与目录结构
```bash
git clone https://github.com/kunkunking66/Astral3d-editor-with-rocksi.git
cd Astral3d-editor-with-rocksi
```

**目录结构:**
```text
Astral3d-editor-with-rocksi/
├── Astral3DEditor/            # 前端代码（Vue + Vite）
├── Astral3DEditorGoBack/      # 后端代码（Go + Beego）
└── Rocksi-master              # 已嵌入 (html + js)
└── README.md
```

### 3.2. 关键配置文件说明

#### 3.2.1. 后端数据库连接 `Astral3DEditorGoBack/conf/app.conf`
确认配置如下 (✅ 推荐配置):
```ini
[sql]
conn = "astral:Astral@2025!@tcp(127.0.0.1:3306)/astral3d?charset=utf8mb4&parseTime=true&loc=Local"
```
> ⚠️ 注意密码中含 `@` 等特殊字符时，务必完整写在配置项中，避免 Go 后端连接失败。


#### 3.2.2. 前端环境变量 astral3deditor-env
放在 Astral3DEditor/.env 目录(Ctrl+H)，示例：
```env
VITE_PORT=3000
VITE_GLOB_APP_TITLE='Astral 3D Editor'
VITE_GLOB_AUTHOR='ErSan'
VITE_GLOB_VERSION='1.0.0'
VITE_GLOB_BEIAN='XICP备XXXXXXXXXX号'
# 代理后端地址
VITE_PROXY_URL=http://127.0.0.1:8080
```

---

#### 3.2.3. 前端开发环境变量 astral3deditor-envdevelopment
放在 `Astral3DEditor/.env.development` 目录 (Ctrl+H)，示例：
```env
# dev server 端口
VITE_PORT=3000  

# 静态资源前缀
VITE_PUBLIC_PATH = /

# REST / 文件代理到后端
VITE_PROXY_URL = http://127.0.0.1:8080

# WebSocket 地址（前端自己用）
VITE_GLOB_SOCKET_URL = ws://127.0.0.1:8080/api/sys/ws
```

---

## 4. 启动与验证

### 4.1. 启动步骤

#### 4.1.1. 启动 MySQL 服务
```bash
sudo systemctl start mysql
sudo systemctl status mysql
```

#### 4.1.2. 启动后端服务
进入后端目录 `Astral3DEditorGoBack`：
```bash
# 如果未安装 bee
go install github.com/beego/bee/v2@latest

# 设置环境变量 (如果需要)
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc
which bee

# 启动服务
bee run
```

#### 4.1.3. 启动前端服务
进入前端目录 `Astral3DEditor`(注意路径)：
```bash
cd ../Astral3DEditor
npm install
# 如果遇到依赖问题，可尝试
npm install --legacy-peer-deps
npm run dev
```

#### 4.1.4. 启动 Rocksi (用于集成开发)
1. 进入 Rocksi 项目目录（注意路径）：
```bash
cd ~/astral3d-editor-with-rocksi/Rocksi-master
```
2. 启动开发服务器：
```bash
# npm install --legacy-peer-deps
npm install
npm run dev
```
> Rocksi 启动后，可以集成到原本的 `http://localhost:3000/` 中进行使用。

#### 4.1.5. 一键启动脚本
为了方便，您可以在安装完成依赖之后使用项目根目录的一键启动脚本：
```bash
cd ~/Astral3d-editor-with-rocksi
chmod +x start-all.sh
./start-all.sh
```

### 4.2. 运行成功表现

*   **后端启动成功**控制台显示：
    ```text
    ______
    | ___ \
    | |_/ /  ___   ___
    | ___ \ / _ \ / _ \
    | |_/ /|  __/|  __/
    \____/  \___| \___| v2.3.0
    ...
    http server Running on http://:8080
    ```
*   **前端启动成功**控制台显示：
    ```text
    VITE v5.0.12  ready in xxx ms
    ➜  Local:   http://localhost:3000/
    ➜  Network: http://192.168.x.x:3000/
    ```
*   **Rocksi 启动成功**控制台显示：
    ```text
    > robotsim@1.0.0 dev
    > parcel serve ./index.html --out-dir dist/dev/

    Server running at http://localhost:1234
    ```
*   **浏览器访问** `http://localhost:3000`，显示3D编辑器页面，无报错。

---

## 5. 开发与扩展指南

### 5.1. 开发一：如何添加一个自定义 Blockly Block（以 `suspend` 为例）

为 Rocksi 编辑器添加自定义 Blockly Block，需要在多个文件中协调定义 UI、代码生成、语言包和执行逻辑。

#### 步骤 1. 创建 Block 配置文件
**路径**：`src/blockly/blocks/extras/suspend.json`
```json
{
  "type": "suspend",
  "message0": "%{BKY_ROCKSI_BLOCK_SUSPEND}",
  "tooltip": "%{BKY_ROCKSI_BLOCK_SUSPEND_TOOLTIP}",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230
}
```

#### 步骤 2. 定义代码生成器
**路径**：`src/blockly/generators/javascript.js`
```javascript
Blockly.JavaScript["suspend"] = function (block) {
    return 'Simulation.instance.suspend();\n';
};
```

#### 步骤 3. 添加语言包词条
**英文：`src/i18n/blockly_en.js`**
```javascript
export const BlocklyCustomEN = {
  // ...
  ROCKSI_BLOCK_SUSPEND: "Suspend program",
  ROCKSI_BLOCK_SUSPEND_TOOLTIP: "Temporarily stop program execution",
};
```
**德文 (可选)：`src/i18n/blockly_de.js`**
```javascript
export const BlocklyCustomDE = {
  // ...
  ROCKSI_BLOCK_SUSPEND: "Programm anhalten",
  ROCKSI_BLOCK_SUSPEND_TOOLTIP: "Hält das Programm temporär an",
};
```> ⚠️ 注意：不要加 `BKY_` 前缀，Blockly 会自动加。

#### 步骤 4. 实现逻辑方法
**路径**：`src/simulator/simulation.js`
在 `TheSimulation` 类中添加：
```javascript
suspend() {
    console.log('> Suspending simulation...');
    this.cancel();
}
```

#### 步骤 5. 注册 Interpreter API
**路径**：`src/blockly/blockly.js`
```javascript
const simObj = interpreter.createObjectProto(interpreter.OBJECT);
const simInstance = interpreter.createObjectProto(interpreter.OBJECT);

interpreter.setProperty(simInstance, 'suspend',
    interpreter.createNativeFunction(() => {
        simulation.suspend();
    })
);

interpreter.setProperty(simObj, 'instance', simInstance);
interpreter.setProperty(globalObject, 'Simulation', simObj);
```

#### 步骤 6. 加入 Toolbox 工具箱
**路径**：`src/blockly/toolbox.xml`
```xml
<block type="suspend"></block>
```

#### ✅ 总结表格
| 文件路径 | 作用 | 内容摘要 |
| --- | --- | --- |
| `blocks/extras/suspend.json` | Block 的结构定义 | `%{BKY_ROCKSI_BLOCK_SUSPEND}` |
| `generators/javascript.js` | 生成 JS 代码 | `Simulation.instance.suspend();` |
| `i18n/blockly_en.js` | 英文词条 | `ROCKSI_BLOCK_SUSPEND` 等 |
| `simulation.js` | 模拟器执行逻辑 | 添加 `suspend()` 方法 |
| `blockly.js` | 注册 Interpreter API | `interpreter.setProperty` |
| `toolbox.xml` | 将 Block 显示到编辑器中 | `<block type="suspend" />` |

### 5.2. 开发二：多机器人模型选择支持说明 (Robot Selector Support)
通过本功能，用户可以在页面上通过下拉菜单选择不同的机器人模型进行加载与控制，无需手动修改代码或刷新参数。

#### 目录结构约定
所有可加载模型均位于路径：`/Rocksi-master/assets/models/`
例如现已支持的模型有：
```bash
franka_description
niryo_robot_description
sawyer_description
```

#### 修改记录
**1. 修改 `index.html`**
在 `<body>` 内合适位置添加如下 HTML 片段：
```html
<!-- Robot Selector UI -->
<div id="robot-selector" style="position: fixed; top: 10px; left: 10px; z-index: 9999; background: white; padding: 5px 10px; border-radius: 6px; box-shadow: 0 2px 5px rgba(0,0,0,0.15);">
  <label for="robotSelect" style="margin-right: 6px;">Robot:</label>
  <select id="robotSelect">
    <option value="niryo_robot_description">Niryo</option>
    <option value="franka_description">Franka</option>
    <option value="sawyer_description">Sawyer</option>
  </select>
</div>
```

**2. 修改 `src/index.js`**
在文件底部添加以下 JavaScript 逻辑：
```javascript
$(document).ready(function () {
    // 设置默认选中项
    const params = new URLSearchParams(window.location.search);
    const selectedRobot = params.get('robot') || 'niryo_robot_description';
    document.getElementById('robotSelect').value = selectedRobot;

    // 切换模型并刷新页面
    document.getElementById('robotSelect').addEventListener('change', function (e) {
        const newRobot = e.target.value;
        const newParams = new URLSearchParams(window.location.search);
        newParams.set('robot', newRobot);
        window.location.search = newParams.toString();  // 页面重载
    });
});
```

**3. `src/helpers.js` (无需修改)**
默认逻辑已存在，自动读取 URL 参数：
```javascript
export function getDesiredRobot() {
    let params = new URLSearchParams(location.search);
    return params.get('robot') || 'niryo';
}
```

---

## 6. 其他信息

### 6.1. 常见问题与解决方案 (FAQ)
| 问题 | 可能原因 | 解决建议 |
| --- | --- | --- |
| `Access denied for user` | 密码错误 / host 不匹配 / 权限未刷新 | 重设用户并执行 `FLUSH PRIVILEGES;` |
| `Unknown database` | 数据库名拼写错误 / 未创建 | 执行 `CREATE DATABASE astral3d;` |
| `connect: connection refused` | MySQL 未启动 | 执行 `sudo service mysql start` |
| MySQL连接失败，socket路径错误 | 使用正确socket参数 | 如 `--socket=/var/run/mysqld/mysqld.sock` |
| 表不存在错误 | 未执行建表SQL | 确认连接的数据库和表名是否一致 |
| 字段类型过大错误 (coverPicture) | `VARCHAR` 长度不足 | 修改字段类型为 `TEXT` |
| 后端启动报错 "register db Ping" 失败 | 数据库配置错误 | 确认数据库名、用户、密码匹配 |
| 密码中含 `@` | 没有 URL 编码或配置不规范 | 建议密码不包含特殊符号，或将整个连接字符串用引号包裹 |

### 6.2. 版本兼容性与注意事项
*   Go建议使用1.20及以上版本。
*   Bee框架版本为v2.3.0及以上。
*   Node.js建议16.x或18.x。
*   MySQL推荐8.0，使用utf8mb4字符集。
*   注意MySQL socket路径，Linux不同发行版路径可能不同。
*   前端使用Vite 5.x，Unocss插件版本不稳定，警告无阻使用。
*   端口默认：前端3000，后端8080。
*   代码目录清晰分前端后端，启动顺序必须 **数据库 → 后端 → 前端**。
*   你遇到的主要问题总结及解决 (已整合入FAQ)。
