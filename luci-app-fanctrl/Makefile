include $(TOPDIR)/feeds/luci/luci.mk

LUCI_TITLE:=LuCI Interface for Fan Control
LUCI_DESCRIPTION:=Web interface for PWM fan control
LUCI_DEPENDS:=+fanctrl +luci-lib-json +luci-compat
LUCI_PKGARCH:=all

# 分类和子菜单设置
LUCI_CATEGORY:=LuCI
LUCI_SUBMENU:=3. Applications

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-fanctrl
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=$(LUCI_SUBMENU)
  TITLE:=$(LUCI_TITLE)
  DEPENDS:=$(LUCI_DEPENDS)
  PKGARCH:=all
endef

define Package/luci-app-fanctrl/install
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci
    cp -pR $(PKG_BUILD_DIR)/luci/* $(1)/usr/lib/lua/luci/
    
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
    $(INSTALL_DATA) $(PKG_BUILD_DIR)/po/zh-cn/*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,luci-app-fanctrl))
