# -*- coding: utf-8 -*-
#
# Cookbook Name:: sentry cookbook
# Recipe:: default
#
# :copyright: (c) 2012 - 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/sentry-cookbook
#

include_recipe "sentry::default"

Chef::Log.info("Making nginx frontend for sentry service")


ruby_block "setup-static-dir" do
  block do
    path = `#{node["sentry"]["virtualenv"]}/bin/python -c "import sentry, os; print(os.path.dirname(sentry.__file__));"`
    node.default["sentry"]["static_dir"] = "#{path.strip()}/static/"
  end
  action :create
end


template "#{node[:nginx][:dir]}/sites-available/sentry.conf" do
  source 'nginx.conf.erb'
  owner user
  group user

  notifies :reload, resources(:service => "nginx")
end

nginx_site "sentry.conf"
