include $(TOPDIR)/rules.mk

PKG_NAME:=fanctrl
PKG_VERSION:=2.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Your Name <your@email.com>
PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

# 定义包的基本信息
define Package/fanctrl
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Intelligent Fan Control Daemon
  DEPENDS:=+bash +coreutils
  PKGARCH:=all
endef

# 包描述
define Package/fanctrl/description
 Adaptive PWM fan control with temperature monitoring.
endef

# 配置文件声明
define Package/fanctrl/conffiles
/etc/config/fan_ctrl
endef

# 准备阶段：复制文件到构建目录
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef

# 无需编译步骤（空定义）
define Build/Compile
endef

# 安装阶段：部署文件到固件
define Package/fanctrl/install
	# 安装配置文件
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/etc/config/fan_ctrl $(1)/etc/config/
	
	# 安装初始化脚本
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/init.d/fan_ctrl $(1)/etc/init.d/
	
	# 安装主程序
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/fan_ctrl.sh $(1)/usr/bin/
endef

# 生成包
$(eval $(call BuildPackage,fanctrl))
