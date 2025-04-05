include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-fanh69k
PKG_VERSION:=1.0
PKG_RELEASE:=1

# 关键配置：定义菜单分类和依赖
LUCI_TITLE:=H69K Fan Control
LUCI_DEPENDS:=+luci-base +luci-compat
LUCI_PKGARCH:=all
LUCI_CATEGORY:=LuCI
LUCI_SUBMENU:=Applications  # 确保应用出现在 Applications 子菜单

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/luci/luci.mk  # 正确包含 luci.mk

define Package/$(PKG_NAME)/conffiles
/etc/config/fanh69k
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/fanh69k $(1)/etc/config/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/fanh69k $(1)/etc/init.d/
	
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./root/usr/sbin/fanh69k $(1)/usr/sbin/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/fanh69k.lua $(1)/usr/lib/lua/luci/controller/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/fanh69k.lua $(1)/usr/lib/lua/luci/model/cbi/
	
	$(INSTALL_DIR) $(1)/www/luci-static/resources/fanh69k
	$(INSTALL_DATA) ./htdocs/luci-static/resources/fanh69k/status.htm $(1)/www/luci-static/resources/fanh69k/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) ./po/zh_Hans/fanh69k.po $(1)/usr/lib/lua/luci/i18n/fanh69k.zh-cn.po
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
