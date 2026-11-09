--
-- XXL-JOB
-- Copyright (c) 2015-present, xuxueli.
--
-- DM8 (达梦) Database Init Script
--

-- xxl_job_info
CREATE TABLE xxl_job_info
(
    id                        INT IDENTITY(1,1) NOT NULL,
    job_group                 INT NOT NULL,
    job_desc                  VARCHAR(255) NOT NULL,
    add_time                  DATETIME DEFAULT NULL,
    update_time               DATETIME DEFAULT NULL,
    author                    VARCHAR(64) DEFAULT NULL,
    alarm_email               VARCHAR(255) DEFAULT NULL,
    schedule_type             VARCHAR(50) NOT NULL DEFAULT 'NONE',
    schedule_conf             VARCHAR(128) DEFAULT NULL,
    misfire_strategy          VARCHAR(50) NOT NULL DEFAULT 'DO_NOTHING',
    executor_route_strategy   VARCHAR(50) DEFAULT NULL,
    executor_handler          VARCHAR(255) DEFAULT NULL,
    executor_param            VARCHAR(512) DEFAULT NULL,
    executor_block_strategy   VARCHAR(50) DEFAULT NULL,
    executor_timeout          INT NOT NULL DEFAULT 0,
    executor_fail_retry_count INT NOT NULL DEFAULT 0,
    glue_type                 VARCHAR(50) NOT NULL,
    glue_source               CLOB,
    glue_remark               VARCHAR(128) DEFAULT NULL,
    glue_updatetime           DATETIME DEFAULT NULL,
    child_jobid               VARCHAR(255) DEFAULT NULL,
    trigger_status            TINYINT NOT NULL DEFAULT 0,
    trigger_last_time         BIGINT NOT NULL DEFAULT 0,
    trigger_next_time         BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

-- xxl_job_log
CREATE TABLE xxl_job_log
(
    id                        BIGINT IDENTITY(1,1) NOT NULL,
    job_group                 INT NOT NULL,
    job_id                    INT NOT NULL,
    executor_address          VARCHAR(255) DEFAULT NULL,
    executor_handler          VARCHAR(255) DEFAULT NULL,
    executor_param            VARCHAR(512) DEFAULT NULL,
    executor_sharding_param   VARCHAR(20) DEFAULT NULL,
    executor_fail_retry_count INT NOT NULL DEFAULT 0,
    trigger_time              DATETIME DEFAULT NULL,
    trigger_code              INT NOT NULL,
    trigger_msg               TEXT,
    handle_time               DATETIME DEFAULT NULL,
    handle_code               INT NOT NULL,
    handle_msg                TEXT,
    alarm_status              TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);
CREATE INDEX I_trigger_time ON xxl_job_log(trigger_time);
CREATE INDEX I_handle_code ON xxl_job_log(handle_code);
CREATE INDEX I_jobid_jobgroup ON xxl_job_log(job_id, job_group);
CREATE INDEX I_job_id ON xxl_job_log(job_id);

-- xxl_job_log_report
CREATE TABLE xxl_job_log_report
(
    id            INT IDENTITY(1,1) NOT NULL,
    trigger_day   DATETIME DEFAULT NULL,
    running_count INT NOT NULL DEFAULT 0,
    suc_count     INT NOT NULL DEFAULT 0,
    fail_count    INT NOT NULL DEFAULT 0,
    update_time   DATETIME DEFAULT NULL,
    PRIMARY KEY (id)
);
CREATE UNIQUE INDEX i_trigger_day ON xxl_job_log_report(trigger_day);

-- xxl_job_logglue
CREATE TABLE xxl_job_logglue
(
    id          INT IDENTITY(1,1) NOT NULL,
    job_id      INT NOT NULL,
    glue_type   VARCHAR(50) DEFAULT NULL,
    glue_source CLOB,
    glue_remark VARCHAR(128) NOT NULL,
    add_time    DATETIME DEFAULT NULL,
    update_time DATETIME DEFAULT NULL,
    PRIMARY KEY (id)
);

-- xxl_job_registry
CREATE TABLE xxl_job_registry
(
    id             INT IDENTITY(1,1) NOT NULL,
    registry_group VARCHAR(50) NOT NULL,
    registry_key   VARCHAR(255) NOT NULL,
    registry_value VARCHAR(255) NOT NULL,
    update_time    DATETIME DEFAULT NULL,
    PRIMARY KEY (id)
);
CREATE UNIQUE INDEX i_g_k_v ON xxl_job_registry(registry_group, registry_key, registry_value);

-- xxl_job_group
CREATE TABLE xxl_job_group
(
    id           INT IDENTITY(1,1) NOT NULL,
    app_name     VARCHAR(64) NOT NULL,
    title        VARCHAR(12) NOT NULL,
    address_type TINYINT NOT NULL DEFAULT 0,
    address_list TEXT,
    update_time  DATETIME DEFAULT NULL,
    PRIMARY KEY (id)
);

-- xxl_job_user
CREATE TABLE xxl_job_user
(
    id         INT IDENTITY(1,1) NOT NULL,
    username   VARCHAR(50) NOT NULL,
    password   VARCHAR(50) NOT NULL,
    role       TINYINT NOT NULL,
    permission VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id)
);
CREATE UNIQUE INDEX i_username ON xxl_job_user(username);

-- xxl_job_lock
CREATE TABLE xxl_job_lock
(
    lock_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (lock_name)
);

-- —————————————————————— init data ——————————————————

SET IDENTITY_INSERT xxl_job_group ON;
INSERT INTO xxl_job_group(id, app_name, title, address_type, address_list, update_time)
VALUES (1, 'xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31');
SET IDENTITY_INSERT xxl_job_group OFF;

SET IDENTITY_INSERT xxl_job_info ON;
INSERT INTO xxl_job_info(id, job_group, job_desc, add_time, update_time, author, alarm_email,
                           schedule_type, schedule_conf, misfire_strategy, executor_route_strategy,
                           executor_handler, executor_param, executor_block_strategy, executor_timeout,
                           executor_fail_retry_count, glue_type, glue_source, glue_remark, glue_updatetime,
                           child_jobid)
VALUES (1, 1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *',
        'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化',
        '2018-11-03 22:21:31', '');
SET IDENTITY_INSERT xxl_job_info OFF;

SET IDENTITY_INSERT xxl_job_user ON;
INSERT INTO xxl_job_user(id, username, password, role, permission)
VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
SET IDENTITY_INSERT xxl_job_user OFF;

INSERT INTO xxl_job_lock (lock_name)
VALUES ('schedule_lock');

commit;
