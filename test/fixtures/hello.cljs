(ns hello.core)

(defn -main [] (println "Hello World"))

(set! *main-cli-fn* -main)