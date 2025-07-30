package controllers

import "es-3d-editor-go-back/server"

type SimulationController struct {
	BaseController
}

// 示例方法：启动仿真
func (c *SimulationController) StartSimulation() {
	// 正确使用 server.ResultJson 结构（完全匹配字段名）
	c.Data["json"] = server.ResultJson{
		Code:    200,                    // int
		Type:    "success",              // string
		Result:  "仿真已启动",              // interface{}（可以是任意类型）
		Message: "Simulation started",   // string
	}
	_ = c.ResponseJson()
}

// 或者直接使用包提供的快捷方法（推荐）
func (c *SimulationController) StartSimulationV2() {
	// 使用 server.RequestSuccess 构造标准响应
	c.Data["json"] = server.RequestSuccess("仿真已启动")
	_ = c.ResponseJson()
}
