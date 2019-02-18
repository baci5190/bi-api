<?php 
class Logger() {

    static $logger = null;
    __construct(){
        use MonologLogger;
        use MonologHandlerStreamHandler;

        $logger = new Logger('channel-name');
        $logger->pushHandler(new StreamHandler(ROOT . '/app.log', Logger::DEBUG));
        $logger->info('Initialize logger');
    }

    /**
     * return an instance of the Logger object
    * @return type
    */
    public static function get() {
    if (null === static::$logger) {
            static::$logger = new static();
        }

        return static::$logger;
    }

    protected function __construct() {
        
    }

    private function __clone() {
        
    }

    private function __wakeup() {
        
    }
}