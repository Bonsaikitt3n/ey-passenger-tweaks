if node[:environment][:framework_env] == 'production'
  # Add your appname here
  app_name = node[:environment][:name]
  # Add the new worker count you want
  worker_count = 4
  # Add the memory limit you want to pass
  # to passenger_monitor in MB
  memory_limit = 600

  if ['app_master', 'app', 'solo'].include?(node[:instance_role])
    ey_cloud_report "passenger" do
      message "changing passenger settings"
    end

    cron "passenger_monitor_#{app_name}" do
      minute  '*'
      hour    '*'
      day     '*'
      month   '*'
      weekday '*'
      command "/usr/bin/lockrun --lockfile=/var/run/passenger_monitor_#{app_name}.lockrun -- /bin/bash -c '/engineyard/bin/passenger_monitor #{app_name} -l #{memory_limit} >/dev/null 2>&1'"
    end
  end
end