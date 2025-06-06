package request

import (
	common "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/system"
)

// Register User register structure
type Register struct {
	Username     string `json:"userName" example:"用户名"`
	Password     string `json:"passWord" example:"密码"`
	NickName     string `json:"nickName" example:"昵称"`
	HeaderImg    string `json:"headerImg" example:"头像链接"`
	AuthorityId  uint   `json:"authorityId" swaggertype:"string" example:"int 角色id"`
	Enable       int    `json:"enable" swaggertype:"string" example:"int 是否启用"`
	AuthorityIds []uint `json:"authorityIds" swaggertype:"string" example:"[]uint 角色id"`
	Phone        string `json:"phone" example:"电话号码"`
	Email        string `json:"email" example:"电子邮箱"`
}

// User login structure
type Login struct {
	Username  string `json:"username"`  // 用户名
	Password  string `json:"password"`  // 密码
	Captcha   string `json:"captcha"`   // 验证码
	CaptchaId string `json:"captchaId"` // 验证码ID
}

// Modify password structure
type ChangePasswordReq struct {
	ID          uint   `json:"-"`           // 从 JWT 中提取 user id，避免越权
	Password    string `json:"password"`    // 密码
	NewPassword string `json:"newPassword"` // 新密码
}

// Modify  user's auth structure
type SetUserAuth struct {
	AuthorityId uint `json:"authorityId"` // 角色ID
}

// Modify  user's auth structure
type SetUserAuthorities struct {
	ID           uint
	AuthorityIds []uint `json:"authorityIds"` // 角色ID
}

type ChangeUserInfo struct {
	ID           uint                  `gorm:"primarykey"`                                                                                   // 主键ID
	NickName     string                `json:"nickName" gorm:"default:系统用户;comment:用户昵称"`                                                    // 用户昵称
	Phone        string                `json:"phone"  gorm:"comment:用户手机号"`                                                                  // 用户手机号
	AuthorityIds []uint                `json:"authorityIds" gorm:"-"`                                                                        // 角色ID
	Email        string                `json:"email"  gorm:"comment:用户邮箱"`                                                                   // 用户邮箱
	HeaderImg    string                `json:"headerImg" gorm:"default:https://qmplusimg.henrongyi.top/1576554439myAvatar.png;comment:用户头像"` // 用户头像
	SideMode     string                `json:"sideMode"  gorm:"comment:用户侧边主题"`                                                              // 用户侧边主题
	Enable       int                   `json:"enable" gorm:"comment:冻结用户"`                                                                   //冻结用户
	GlobalCode   bool                  `json:"global_code" gorm:"comment:全局代码执行权限"`                                                          //全局代码执行权限 Extend global code
	Authorities  []system.SysAuthority `json:"-" gorm:"many2many:sys_user_authority;"`
}

type GetUserList struct {
	common.PageInfo
	Username string `json:"username" form:"username"`
	NickName string `json:"nickName" form:"nickName"`
	Phone    string `json:"phone" form:"phone"`
	Email    string `json:"email" form:"email"`
}

// Extend Start GetUserInfoByUserName

// GetUserInfoByUserName DingTalk API: Get User Info By UserName
type GetUserInfoByUserName struct {
	ResList struct {
		Name      string `json:"name"`
		UserID    string `json:"userId"`
		Mobile    string `json:"mobile"`
		WorkPlace string `json:"workPlace"`
	} `json:"resList"`
}

// UpdateUserPasswd update user pass my
type UpdateUserPasswd struct {
	ID       uint   `json:"ID"`       // id
	Password string `json:"Password"` // 密码
}

// Extend Stop GetUserInfoByUserName
