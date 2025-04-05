include $(TOPDIR)/rules.mk

LUCI_TITLE:=Fan Control Configuration Interface
LUCI_DESCRIPTION:=Web interface for PWM fan speed control
LUCI_DEPENDS:=+fanctrl +luci-base +luci-compat +luci-lib-json
LUCI_PKGARCH:=all
LUCI_CATEGORY:=LuCI
LUCI_SUBMENU:=Applications

PKG_NAME:=luci-app-fanctrl
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_MAINTAINER:=Your Name <your@email.com>

include $(TOPDIR)/feeds/luci/luci.mk

# 定义构建准备阶段
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/luci
	$(CP) ./files/* $(PKG_BUILD_DIR)/luci/
endef

# 定义空编译步骤（无需编译代码）
define Build/Compile
endef

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=$(LUCI_SUBMENU)
  TITLE:=$(LUCI_TITLE)
  DEPENDS:=$(LUCI_DEPENDS)
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
$(LUCI_DESCRIPTION)
endef

# 安装阶段
define Package/$(PKG_NAME)/install
	# 安装 LuCI 控制器
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/luci/controller/fan_ctrl.lua $(1)/usr/lib/lua/luci/controller/
	
	# 安装 CBI 模型
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/fan_ctrl
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/luci/model/cbi/fan_ctrl/basic.lua $(1)/usr/lib/lua/luci/model/cbi/fan_ctrl/
	
	# 安装视图模板
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/fan_ctrl
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/luci/view/fan_ctrl/* $(1)/usr/lib/lua/luci/view/fan_ctrl/
	
	# 安装语言文件
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/luci/i18n/*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
