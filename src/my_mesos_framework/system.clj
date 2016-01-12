(ns my-mesos-framework.system
  (:require [com.stuartsierra.component :as component]
            [my-mesos-framework.component.executor-driver :refer [new-executor-driver]]
            [my-mesos-framework.component.scheduler-driver :refer [new-scheduler-driver]]
            [my-mesos-framework.component.scheduler :refer [new-scheduler]]
            [my-mesos-framework.executor :refer [executor]]
            [my-mesos-framework.scheduler :refer [scheduler] :as sched])
  (:gen-class))

(defn executor-system
  []
  (component/system-map
   :driver (new-executor-driver (executor))))

(defn scheduler-system
  [master n-tasks task-launcher]
  (component/system-map
   :scheduler (new-scheduler n-tasks task-launcher)
   :driver (component/using
            (new-scheduler-driver master)
            [:scheduler])))

(defn -main
  [command-type & [scheduler-type master n-tasks & _]]
  (let [system (condp = [command-type scheduler-type]
                 ["scheduler" "jar"] (scheduler-system master n-tasks sched/jar-task-info)
                 ["scheduler" "shell"] (scheduler-system master n-tasks sched/shell-task-info)
                 ["scheduler" "docker"] (scheduler-system master n-tasks sched/docker-task-info)
                 ["executor" nil] (executor-system))]
    (component/start system)
    (while true
      (Thread/sleep 1000000))))
