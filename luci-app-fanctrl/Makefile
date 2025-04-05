include $(TOPDIR)/rules.mk

LUCI_TITLE:=Fan Control Configuration Interface
LUCI_DESCRIPTION:=Web interface for PWM fan speed control based on temperature
LUCI_DEPENDS:=+fanctrl +luci-base +luci-compat +luci-lib-json
LUCI_PKGARCH:=all
LUCI_CATEGORY:=LuCI
LUCI_SUBMENU:=Applications

PKG_NAME:=luci-app-fanctrl
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_MAINTAINER:=Your Name <your@email.com>

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=$(LUCI_SUBMENU)
  TITLE:=$(LUCI_TITLE)
  DEPENDS:=$(LUCI_DEPENDS)
  PKGARCH:=$(LUCI_PKGARCH)
endef

define Package/$(PKG_NAME)/description
$(LUCI_DESCRIPTION)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR $(PKG_BUILD_DIR)/luci/* $(1)/usr/lib/lua/luci/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/fan_ctrl.po $(1)/usr/lib/lua/luci/i18n/fan_ctrl.zh-cn.lmo
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/99-fanctrl $(1)/etc/uci-defaults/
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	rm -f /tmp/luci-indexcache 2>/dev/null
	/etc/init.d/rpcd reload >/dev/null 2>&1
}
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
