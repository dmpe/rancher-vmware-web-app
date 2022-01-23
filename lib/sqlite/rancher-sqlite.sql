CREATE OR REPLACE DATABASE api; 

CREATE OR REPLACE TABLE api.vmware_master_data (
    host_name varchar(15) not null WITHOUT SYSTEM VERSIONING,
    host_id int primary key not null WITHOUT SYSTEM VERSIONING,
    host_type varchar(1) as (SUBSTRING(host_name,6,1)) VIRTUAL, -- calculated virtual column
    vmware_created boolean default false, -- Has VM been created in VMware (1/true - 0/false) 
    rancher_allocated boolean default false, -- Has VM been allocated to some Rancher cluster (1/true - 0/false)
    ip INET6 null -- VM IP Address
  ) WITH SYSTEM VERSIONING;

CREATE OR REPLACE TABLE api.vmware_master_data_ci_jobs (
    entry_id SERIAL primary key not null,
    host_id int, -- VMware host_id
    jenkins_job_id VARCHAR(100) null,
    gitlab_ci_job_url VARCHAR(200) null,
    CONSTRAINT vmware_master_data_ci_jobs_host_id FOREIGN KEY(host_id) REFERENCES api.vmware_master_data(host_id)
  );

CREATE OR REPLACE VIEW api.free_hostnames AS
SELECT *
FROM api.vmware_master_data as md
WHERE md.rancher_allocated IS False AND md.vmware_created IS False -- DEBUG OFF: AND md.ROW_END < NOW() - INTERVAL 2 day
ORDER BY md.ROW_END DESC; 

insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (1, 'avk8st-node1', "test", true, true, '::44.222.230.96');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (2, 'avk8st-node2', "test", true, false, '::173.227.162.208');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (3, 'avk8st-node3', "test", false, true, '::16.214.217.133');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (4, 'avk8st-node4', "test", true, false, '::172.249.200.6');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (5, 'avk8st-node5', "test", true, true, '::10.57.93.88');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (6, 'avk8st-node6', "test", true, true, '::248.147.16.127');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (7, 'avk8st-node7', "test", false, false, '::155.133.115.228');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (8, 'avk8st-node8', "test", false, false, '::129.44.182.55');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (9, 'avk8st-node9', "test", true, true, '::74.41.2.36');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (10, 'avk8st-node10', "test", true, true, '::239.56.117.140');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (11, 'avk8st-node11', "test", true, false, '::119.225.94.110');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (12, 'avk8st-node12', "test", true, false, '::158.207.45.121');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (13, 'avk8st-node13', "test", true, true, '::194.52.89.227');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (14, 'avk8st-node14', "test", false, false, '::110.193.187.173');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (15, 'avk8st-node15', "test", true, false, '::77.17.148.138');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (16, 'avk8st-node16', "test", false, true, '::108.205.31.98');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (17, 'avk8st-node17', "test", true, true, '::203.140.123.196');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (18, 'avk8st-node18', "test", false, false, '::35.240.183.104');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (19, 'avk8st-node19', "test", true, true, '::128.115.109.200');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (20, 'avk8st-node20', "test", true, false, '::99.32.165.1');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (21, 'avk8st-node21', "test", false, false, '::203.15.103.16');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (22, 'avk8st-node22', "test", true, true, '::28.121.120.255');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (23, 'avk8st-node23', "test", true, true, '::5.117.112.45');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (24, 'avk8st-node24', "test", false, true, '::61.250.93.106');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (25, 'avk8st-node25', "test", true, false, '::110.236.191.61');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (26, 'avk8st-node26', "test", true, false, '::186.218.177.235');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (27, 'avk8st-node27', "test", false, true, '::102.41.122.54');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (28, 'avk8st-node28', "test", true, false, '::144.19.243.31');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (29, 'avk8st-node29', "test", false, true, '::146.20.43.146');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (30, 'avk8st-node30', "test", true, false, '::167.109.87.185');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (31, 'avk8st-node31', "test", true, true, '::28.70.164.247');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (32, 'avk8st-node32', "test", true, false, '::90.224.51.94');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (33, 'avk8st-node33', "test", true, false, '::208.242.213.180');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (34, 'avk8st-node34', "test", true, true, '::226.141.96.238');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (35, 'avk8st-node35', "test", false, false, '::239.103.208.220');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (36, 'avk8st-node36', "test", true, false, '::193.208.64.231');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (37, 'avk8st-node37', "test", false, false, '::149.223.173.147');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (38, 'avk8st-node38', "test", false, true, '::230.101.73.125');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (39, 'avk8st-node39', "test", true, false, '::120.242.214.101');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (40, 'avk8st-node40', "test", false, true, '::156.195.75.115');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (41, 'avk8st-node41', "test", true, true, '::133.174.82.171');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (42, 'avk8st-node42', "test", true, false, '::166.46.71.83');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (43, 'avk8st-node43', "test", false, false, '::16.30.224.251');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (44, 'avk8st-node44', "test", true, true, '::65.16.72.3');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (45, 'avk8st-node45', "test", true, true, '::250.229.84.209');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (46, 'avk8st-node46', "test", true, true, '::249.146.174.131');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (47, 'avk8st-node47', "test", true, true, '::4.215.20.9');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (48, 'avk8st-node48', "test", true, true, '::97.240.190.8');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (49, 'avk8st-node49', "test", true, true, '::34.109.99.125');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (50, 'avk8st-node50', "test", true, true, '::111.197.191.6');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (51, 'avk8st-node51', "test", false, false, '::232.219.11.160');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (52, 'avk8st-node52', "test", true, true, '::12.197.216.97');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (53, 'avk8st-node53', "test", false, false, '::145.155.243.211');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (54, 'avk8st-node54', "test", false, true, '::30.163.211.56');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (55, 'avk8st-node55', "test", true, true, '::95.117.66.150');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (56, 'avk8st-node56', "test", true, false, '::109.4.72.106');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (57, 'avk8st-node57', "test", true, false, '::111.94.169.160');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (58, 'avk8st-node58', "test", true, false, '::254.208.36.13');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (59, 'avk8st-node59', "test", true, true, '::185.88.246.86');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (60, 'avk8st-node60', "test", false, false, '::249.163.251.111');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (61, 'avk8st-node61', "test", false, false, '::107.229.16.3');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (62, 'avk8st-node62', "test", false, false, '::48.233.70.187');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (63, 'avk8st-node63', "test", true, true, '::65.169.193.75');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (64, 'avk8st-node64', "test", false, false, '::154.131.204.22');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (65, 'avk8st-node65', "test", false, false, '::88.124.161.224');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (66, 'avk8st-node66', "test", false, true, '::69.247.243.65');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (67, 'avk8st-node67', "test", false, true, '::217.72.253.40');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (68, 'avk8st-node68', "test", true, true, '::225.29.212.191');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (69, 'avk8st-node69', "test", true, false, '::16.58.17.163');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (70, 'avk8st-node70', "test", false, true, '::205.232.88.202');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (71, 'avk8st-node71', "test", true, false, '::128.57.186.209');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (72, 'avk8st-node72', "test", true, false, '::205.10.24.184');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (73, 'avk8st-node73', "test", false, false, '::68.219.177.201');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (74, 'avk8st-node74', "test", true, true, '::108.192.9.248');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (75, 'avk8st-node75', "test", true, true, '::110.166.73.114');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (76, 'avk8st-node76', "test", true, true, '::39.129.135.8');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (77, 'avk8st-node77', "test", true, true, '::5.240.108.13');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (78, 'avk8st-node78', "test", true, true, '::62.102.175.105');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (79, 'avk8st-node79', "test", false, true, '::118.103.104.58');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (80, 'avk8st-node80', "test", false, true, '::71.96.12.133');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (81, 'avk8st-node81', "test", true, true, '::39.200.110.227');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (82, 'avk8st-node82', "test", false, true, '::208.246.30.188');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (83, 'avk8st-node83', "test", false, true, '::95.251.91.118');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (84, 'avk8st-node84', "test", true, false, '::253.90.135.233');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (85, 'avk8st-node85', "test", true, true, '::244.232.217.152');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (86, 'avk8st-node86', "test", true, true, '::41.44.183.149');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (87, 'avk8st-node87', "test", true, false, '::228.5.255.3');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (88, 'avk8st-node88', "test", true, false, '::101.1.121.52');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (89, 'avk8st-node89', "test", false, true, '::72.116.11.37');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (90, 'avk8st-node90', "test", true, false, '::216.129.51.244');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (91, 'avk8st-node91', "test", false, true, '::241.150.122.212');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (92, 'avk8st-node92', "test", true, true, '::244.146.80.231');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (93, 'avk8st-node93', "test", true, true, '::225.191.200.158');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (94, 'avk8st-node94', "test", true, true, '::129.70.3.22');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (95, 'avk8st-node95', "test", true, true, '::120.219.79.161');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (96, 'avk8st-node96', "test", false, true, '::188.134.242.225');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (97, 'avk8st-node97', "test", true, true, '::56.34.89.166');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (98, 'avk8st-node98', "test", false, false, '::235.244.109.28');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (99, 'avk8st-node99', "test", true, true, '::168.70.90.99');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (100, 'avk8st-node100', "test", false, false, '::63.237.188.91');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (101, 'avk8st-node101', "test", false, false, '::199.244.30.57');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (102, 'avk8st-node102', "test", false, false, '::89.221.208.134');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (103, 'avk8st-node103', "test", true, false, '::163.204.213.75');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (104, 'avk8st-node104', "test", false, true, '::133.22.231.138');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (105, 'avk8st-node105', "test", false, true, '::5.64.36.218');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (106, 'avk8st-node106', "test", false, false, '::160.80.103.78');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (107, 'avk8st-node107', "test", true, true, '::10.110.198.161');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (108, 'avk8st-node108', "test", false, false, '::19.86.192.200');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (109, 'avk8st-node109', "test", true, true, '::7.138.160.69');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (110, 'avk8st-node110', "test", true, true, '::63.188.232.105');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (111, 'avk8st-node111', "test", false, false, '::255.15.227.67');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (112, 'avk8st-node112', "test", false, true, '::123.94.87.94');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (113, 'avk8st-node113', "test", true, true, '::26.58.208.123');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (114, 'avk8st-node114', "test", false, true, '::173.192.7.59');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (115, 'avk8st-node115', "test", true, true, '::29.53.71.211');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (116, 'avk8st-node116', "test", false, false, '::224.239.221.197');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (117, 'avk8st-node117', "test", false, true, '::107.32.100.215');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (118, 'avk8st-node118', "test", true, true, '::15.238.181.132');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (119, 'avk8st-node119', "test", false, true, '::194.106.75.159');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (120, 'avk8st-node120', "test", true, false, '::142.214.255.139');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (121, 'avk8st-node121', "test", true, true, '::215.30.102.130');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (122, 'avk8st-node122', "test", false, false, '::188.2.218.163');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (123, 'avk8st-node123', "test", true, true, '::25.255.75.20');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (124, 'avk8st-node124', "test", false, true, '::222.239.81.214');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (125, 'avk8st-node125', "test", false, true, '::97.252.35.211');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (126, 'avk8st-node126', "test", true, true, '::5.133.40.125');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (127, 'avk8st-node127', "test", false, true, '::64.234.241.78');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (128, 'avk8st-node128', "test", true, true, '::130.56.177.23');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (129, 'avk8st-node129', "test", true, true, '::215.38.232.187');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (130, 'avk8st-node130', "test", false, true, '::154.233.164.202');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (131, 'avk8st-node131', "test", true, false, '::252.168.215.204');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (132, 'avk8st-node132', "test", true, true, '::65.144.40.91');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (133, 'avk8st-node133', "test", true, true, '::156.230.106.44');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (134, 'avk8st-node134', "test", false, false, '::237.149.68.36');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (135, 'avk8st-node135', "test", true, false, '::218.49.169.97');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (136, 'avk8st-node136', "test", false, true, '::73.101.29.215');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (137, 'avk8st-node137', "test", false, true, '::131.7.20.81');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (138, 'avk8st-node138', "test", false, false, '::115.102.87.212');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (139, 'avk8st-node139', "test", false, false, '::183.106.87.185');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (140, 'avk8st-node140', "test", false, true, '::162.207.47.150');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (141, 'avk8st-node141', "test", false, false, '::38.46.16.117');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (142, 'avk8st-node142', "test", false, true, '::154.97.201.88');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (143, 'avk8st-node143', "test", false, false, '::85.28.107.226');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (144, 'avk8st-node144', "test", true, false, '::126.182.56.157');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (145, 'avk8st-node145', "test", false, false, '::65.141.53.15');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (146, 'avk8st-node146', "test", false, false, '::195.154.138.57');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (147, 'avk8st-node147', "test", true, false, '::27.215.204.242');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (148, 'avk8st-node148', "test", true, false, '::224.121.146.202');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (149, 'avk8st-node149', "test", false, true, '::57.33.14.178');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (150, 'avk8st-node150', "test", false, true, '::32.144.174.250');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (151, 'avk8st-node151', "test", false, false, '::239.112.68.159');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (152, 'avk8st-node152', "test", false, false, '::177.201.232.214');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (153, 'avk8st-node153', "test", true, false, '::17.32.199.86');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (154, 'avk8st-node154', "test", false, true, '::154.40.162.159');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (155, 'avk8st-node155', "test", false, false, '::99.31.158.242');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (156, 'avk8st-node156', "test", false, true, '::75.148.161.207');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (157, 'avk8st-node157', "test", false, true, '::42.135.190.61');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (158, 'avk8st-node158', "test", true, true, '::49.132.213.130');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (159, 'avk8st-node159', "test", true, true, '::67.202.196.32');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (160, 'avk8st-node160', "test", true, false, '::57.205.168.178');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (161, 'avk8st-node161', "test", false, true, '::177.112.192.118');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (162, 'avk8st-node162', "test", false, false, '::121.161.120.142');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (163, 'avk8st-node163', "test", true, true, '::23.133.143.24');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (164, 'avk8st-node164', "test", true, true, '::25.222.118.16');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (165, 'avk8st-node165', "test", false, true, '::213.69.108.112');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (166, 'avk8st-node166', "test", true, false, '::87.181.255.50');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (167, 'avk8st-node167', "test", true, true, '::121.162.62.183');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (168, 'avk8st-node168', "test", true, true, '::142.195.140.205');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (169, 'avk8st-node169', "test", true, false, '::158.1.167.4');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (170, 'avk8st-node170', "test", false, true, '::150.106.151.32');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (171, 'avk8st-node171', "test", false, true, '::27.81.31.193');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (172, 'avk8st-node172', "test", false, false, '::86.186.205.213');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (173, 'avk8st-node173', "test", false, false, '::106.18.168.53');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (174, 'avk8st-node174', "test", true, false, '::174.181.129.225');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (175, 'avk8st-node175', "test", false, false, '::128.243.136.84');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (176, 'avk8st-node176', "test", true, true, '::155.52.17.254');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (177, 'avk8st-node177', "test", true, true, '::59.107.198.144');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (178, 'avk8st-node178', "test", true, false, '::220.175.85.170');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (179, 'avk8st-node179', "test", false, false, '::20.203.12.160');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (180, 'avk8st-node180', "test", false, true, '::196.137.30.181');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (181, 'avk8st-node181', "test", false, true, '::181.25.39.4');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (182, 'avk8st-node182', "test", false, false, '::159.120.182.184');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (183, 'avk8st-node183', "test", false, true, '::99.226.182.27');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (184, 'avk8st-node184', "test", false, false, '::183.80.90.181');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (185, 'avk8st-node185', "test", false, false, '::216.80.57.41');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (186, 'avk8st-node186', "test", false, false, '::106.132.97.188');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (187, 'avk8st-node187', "test", true, false, '::86.64.187.88');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (188, 'avk8st-node188', "test", true, false, '::255.9.1.165');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (189, 'avk8st-node189', "test", false, false, '::119.63.58.167');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (190, 'avk8st-node190', "test", true, false, '::54.202.226.49');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (191, 'avk8st-node191', "test", false, true, '::92.198.32.196');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (192, 'avk8st-node192', "test", true, true, '::248.28.117.86');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (193, 'avk8st-node193', "test", false, true, '::44.204.181.34');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (194, 'avk8st-node194', "test", false, false, '::128.235.40.253');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (195, 'avk8st-node195', "test", true, true, '::59.197.23.202');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (196, 'avk8st-node196', "test", true, true, '::190.211.31.179');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (197, 'avk8st-node197', "test", true, true, '::254.96.169.238');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (198, 'avk8st-node198', "test", false, false, '::185.24.36.236');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (199, 'avk8st-node199', "test", true, true, '::155.55.144.33');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (200, 'avk8st-node200', "test", true, false, '::222.243.41.157');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (201, 'avk8st-node201', "test", true, true, '::57.100.162.143');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (202, 'avk8st-node202', "test", true, false, '::198.72.115.112');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (203, 'avk8st-node203', "test", true, false, '::119.71.179.250');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (204, 'avk8st-node204', "test", true, true, '::24.202.199.86');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (205, 'avk8st-node205', "test", true, false, '::154.218.105.43');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (206, 'avk8st-node206', "test", true, false, '::82.130.222.102');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (207, 'avk8st-node207', "test", false, true, '::118.222.32.126');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (208, 'avk8st-node208', "test", true, true, '::250.222.131.243');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (209, 'avk8st-node209', "test", true, false, '::244.11.233.8');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (210, 'avk8st-node210', "test", true, false, '::62.167.103.154');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (211, 'avk8st-node211', "test", true, true, '::125.130.104.158');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (212, 'avk8st-node212', "test", true, true, '::96.178.136.37');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (213, 'avk8st-node213', "test", true, true, '::112.248.246.54');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (214, 'avk8st-node214', "test", false, false, '::231.255.194.137');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (215, 'avk8st-node215', "test", false, false, '::35.197.176.126');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (216, 'avk8st-node216', "test", false, false, '::179.208.8.115');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (217, 'avk8st-node217', "test", true, false, '::72.163.101.227');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (218, 'avk8st-node218', "test", true, false, '::110.146.214.25');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (219, 'avk8st-node219', "test", true, true, '::177.255.68.169');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (220, 'avk8st-node220', "test", true, true, '::38.118.105.88');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (221, 'avk8st-node221', "test", false, true, '::115.147.67.45');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (222, 'avk8st-node222', "test", true, false, '::103.6.221.185');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (223, 'avk8st-node223', "test", true, false, '::186.84.172.81');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (224, 'avk8st-node224', "test", false, true, '::83.130.118.36');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (225, 'avk8st-node225', "test", false, false, '::21.130.3.89');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (226, 'avk8st-node226', "test", false, false, '::246.225.34.99');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (227, 'avk8st-node227', "test", false, true, '::174.72.255.204');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (228, 'avk8st-node228', "test", false, true, '::47.110.49.142');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (229, 'avk8st-node229', "test", true, true, '::57.121.246.37');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (230, 'avk8st-node230', "test", true, true, '::108.125.31.162');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (231, 'avk8st-node231', "test", false, false, '::217.211.20.104');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (232, 'avk8st-node232', "test", false, false, '::99.176.32.244');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (233, 'avk8st-node233', "test", false, true, '::202.178.98.177');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (234, 'avk8st-node234', "test", true, true, '::208.21.159.228');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (235, 'avk8st-node235', "test", true, false, '::156.201.65.88');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (236, 'avk8st-node236', "test", false, false, '::141.84.249.92');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (237, 'avk8st-node237', "test", false, false, '::209.12.225.140');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (238, 'avk8st-node238', "test", false, false, '::63.144.132.106');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (239, 'avk8st-node239', "test", false, true, '::238.60.152.125');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (240, 'avk8st-node240', "test", false, false, '::60.180.104.57');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (241, 'avk8st-node241', "test", true, false, '::214.111.252.195');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (242, 'avk8st-node242', "test", false, false, '::114.83.67.136');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (243, 'avk8st-node243', "test", false, false, '::19.71.21.133');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (244, 'avk8st-node244', "test", true, true, '::248.194.99.50');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (245, 'avk8st-node245', "test", false, false, '::27.244.167.144');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (246, 'avk8st-node246', "test", false, false, '::92.214.163.212');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (247, 'avk8st-node247', "test", false, true, '::126.41.56.211');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (248, 'avk8st-node248', "test", true, false, '::158.252.15.193');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (249, 'avk8st-node249', "test", false, true, '::187.131.148.122');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (250, 'avk8st-node250', "test", true, false, '::152.175.208.27');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (251, 'avk8st-node251', "test", true, false, '::144.83.201.190');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (252, 'avk8st-node252', "test", false, true, '::128.133.177.172');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (253, 'avk8st-node253', "test", false, true, '::209.176.203.20');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (254, 'avk8st-node254', "test", false, false, '::180.221.189.44');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (255, 'avk8st-node255', "test", true, true, '::235.78.78.16');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (256, 'avk8st-node256', "test", false, true, '::214.52.101.38');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (257, 'avk8st-node257', "test", true, false, '::106.187.132.141');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (258, 'avk8st-node258', "test", true, true, '::85.182.153.50');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (259, 'avk8st-node259', "test", false, true, '::54.57.237.214');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (260, 'avk8st-node260', "test", false, true, '::16.141.40.146');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (261, 'avk8st-node261', "test", true, false, '::191.59.143.198');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (262, 'avk8st-node262', "test", false, true, '::161.155.55.72');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (263, 'avk8st-node263', "test", false, false, '::99.154.208.127');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (264, 'avk8st-node264', "test", true, false, '::200.13.239.126');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (265, 'avk8st-node265', "test", false, true, '::104.147.123.48');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (266, 'avk8st-node266', "test", false, true, '::102.121.121.17');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (267, 'avk8st-node267', "test", false, true, '::29.37.124.26');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (268, 'avk8st-node268', "test", true, true, '::19.212.149.134');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (269, 'avk8st-node269', "test", true, true, '::191.32.90.33');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (270, 'avk8st-node270', "test", true, true, '::86.119.244.89');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (271, 'avk8st-node271', "test", false, true, '::111.161.41.25');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (272, 'avk8st-node272', "test", true, false, '::157.235.85.241');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (273, 'avk8st-node273', "test", false, true, '::74.144.40.80');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (274, 'avk8st-node274', "test", false, false, '::44.160.51.100');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (275, 'avk8st-node275', "test", false, false, '::235.56.76.120');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (276, 'avk8st-node276', "test", false, false, '::245.13.22.48');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (277, 'avk8st-node277', "test", false, true, '::229.221.64.56');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (278, 'avk8st-node278', "test", false, false, '::82.204.37.232');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (279, 'avk8st-node279', "test", true, false, '::66.4.73.93');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (280, 'avk8st-node280', "test", true, false, '::228.186.29.33');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (281, 'avk8st-node281', "test", true, false, '::90.3.164.235');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (282, 'avk8st-node282', "test", false, true, '::229.153.69.72');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (283, 'avk8st-node283', "test", false, true, '::6.102.100.55');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (284, 'avk8st-node284', "test", true, true, '::25.38.130.35');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (285, 'avk8st-node285', "test", false, true, '::179.244.156.96');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (286, 'avk8st-node286', "test", true, false, '::37.9.185.131');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (287, 'avk8st-node287', "test", false, true, '::28.32.18.211');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (288, 'avk8st-node288', "test", false, true, '::65.156.9.96');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (289, 'avk8st-node289', "test", false, true, '::5.146.158.115');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (290, 'avk8st-node290', "test", false, false, '::86.200.238.162');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (291, 'avk8st-node291', "test", false, true, '::81.224.206.163');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (292, 'avk8st-node292', "test", false, false, '::93.124.64.101');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (293, 'avk8st-node293', "test", true, true, '::68.101.89.60');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (294, 'avk8st-node294', "test", false, false, '::137.255.166.202');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (295, 'avk8st-node295', "test", true, false, '::156.91.199.96');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (296, 'avk8st-node296', "test", false, false, '::82.90.248.129');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (297, 'avk8st-node297', "test", true, true, '::62.177.87.128');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (298, 'avk8st-node298', "test", true, false, '::32.151.167.135');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (299, 'avk8st-node299', "test", false, false, '::190.74.201.211');
insert into api.vmware_master_data (host_id, host_name, host_type, vmware_created, rancher_allocated, ip) values (300, 'avk8st-node300', "test", true, true, '::187.73.28.59');



SELECT *,
  ROW_START,
  ROW_END
FROM api.vmware_master_data;

SELECT *
FROM api.vmware_master_data FOR SYSTEM_TIME ALL;

UPDATE api.vmware_master_data
SET rancher_allocated = true
WHERE host_id = 1;



CREATE OR REPLACE TABLE api.rancher_master_data (      
  cluster_name varchar(50) not null WITHOUT SYSTEM VERSIONING,
  cluster_id varchar(50) not null WITHOUT SYSTEM VERSIONING,                          
  host_id int primary key,  -- VMware host_id
  k8s_role ENUM ('worker', 'control'),
  CONSTRAINT rancher_master_data_host_id FOREIGN KEY(host_id) REFERENCES api.vmware_master_data(host_id)
) WITH SYSTEM VERSIONING;


insert into api.rancher_master_data (cluster_name, cluster_id, host_id, k8s_role) values ('t1', '1asfsadg', 1, 'worker');
insert into api.rancher_master_data (cluster_name, cluster_id, host_id, k8s_role) values ('t1', '1asfsadg', 3, 'worker');
insert into api.rancher_master_data (cluster_name, cluster_id, host_id, k8s_role) values ('t2', 'sdgsdgs', 145, 'worker');
insert into api.rancher_master_data (cluster_name, cluster_id, host_id, k8s_role) values ('p1', 'aqr3r3r', 299, 'worker');

DELIMITER //

CREATE OR REPLACE PROCEDURE api.sp_nodes_in_cluster_name(
    IN in_cl_name VARCHAR(50)
) DETERMINISTIC READS SQL DATA COMMENT 'SP for getting current cluster nodes, based on cluster name'
BEGIN

    SELECT *
    FROM api.rancher_master_data as rmd
    WHERE rmd.cluster_name = in_cl_name;

END //

DELIMITER ;

-- 
--
--

DELIMITER //

CREATE OR REPLACE PROCEDURE api.sp_nodes_in_cluster_id(
    IN in_cl_id VARCHAR(50)
) DETERMINISTIC READS SQL DATA COMMENT 'SP for getting current cluster nodes, based on cluster id'
BEGIN

    SELECT *
    FROM api.rancher_master_data as rmd
    WHERE rmd.cluster_id = in_cl_id;

END //


DELIMITER ;

GRANT ALL PRIVILEGES ON api.* TO 'jm';
FLUSH PRIVILEGES;