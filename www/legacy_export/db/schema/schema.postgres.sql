-- ----------------------------------------------------------
-- MDB Tools - A library for reading MS Access database files
-- Copyright (C) 2000-2011 Brian Bruns and others.
-- Files in libmdb are licensed under LGPL and the utilities under
-- the GPL, see COPYING.LIB and COPYING files respectively.
-- Check out http://mdbtools.sourceforge.net
-- ----------------------------------------------------------

SET client_encoding = 'UTF-8';

CREATE TABLE IF NOT EXISTS "cy_admin"
 (
	"id"			SERIAL, 
	"username"			VARCHAR (16), 
	"pass"			VARCHAR (32), 
	"purview"			TEXT
);

-- CREATE INDEXES ...
CREATE INDEX "cy_admin_id_idx" ON "cy_admin" ("id");
ALTER TABLE "cy_admin" ADD CONSTRAINT "cy_admin_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_announce"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"titlepic"			VARCHAR (100), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"uid"			VARCHAR (50), 
	"genre"			INTEGER, 
	"type"			INTEGER
);
COMMENT ON COLUMN "cy_announce"."type" IS '0: 公告';

-- CREATE INDEXES ...
CREATE INDEX "cy_announce_id_idx" ON "cy_announce" ("id");
ALTER TABLE "cy_announce" ADD CONSTRAINT "cy_announce_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_announce_uid_idx" ON "cy_announce" ("uid");

CREATE TABLE IF NOT EXISTS "cy_announce2"
 (
	"id"			SERIAL, 
	"title"			INTEGER, 
	"titlepic"			VARCHAR (100), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"uid"			VARCHAR (50), 
	"genre"			INTEGER, 
	"type"			INTEGER
);
COMMENT ON COLUMN "cy_announce2"."type" IS '0: 公告';

-- CREATE INDEXES ...
CREATE INDEX "cy_announce2_id_idx" ON "cy_announce2" ("id");
ALTER TABLE "cy_announce2" ADD CONSTRAINT "cy_announce2_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_announce2_uid_idx" ON "cy_announce2" ("uid");

CREATE TABLE IF NOT EXISTS "cy_bumen"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_bumen"."id" IS '分类ID';
COMMENT ON COLUMN "cy_bumen"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_bumen"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_bumen"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_bumen"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_bumen"."img" IS '分类图片';
COMMENT ON COLUMN "cy_bumen"."remark" IS '注释';
COMMENT ON COLUMN "cy_bumen"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_bumen_id_idx" ON "cy_bumen" ("id");
CREATE INDEX "cy_bumen_infonum_idx" ON "cy_bumen" ("infonum");
ALTER TABLE "cy_bumen" ADD CONSTRAINT "cy_bumen_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_bumen_supid_idx" ON "cy_bumen" ("pid");

CREATE TABLE IF NOT EXISTS "cy_cks"
 (
	"id"			SERIAL, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"ip"			VARCHAR (50), 
	"ckid"			INTEGER, 
	"pid"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_cks_ckid_idx" ON "cy_cks" ("ckid");
CREATE INDEX "cy_cks_id_idx" ON "cy_cks" ("id");
CREATE INDEX "cy_cks_pid_idx" ON "cy_cks" ("pid");
ALTER TABLE "cy_cks" ADD CONSTRAINT "cy_cks_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_class"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class"."remark" IS '注释';
COMMENT ON COLUMN "cy_class"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class_id_idx" ON "cy_class" ("id");
CREATE INDEX "cy_class_infonum_idx" ON "cy_class" ("infonum");
ALTER TABLE "cy_class" ADD CONSTRAINT "cy_class_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class_supid_idx" ON "cy_class" ("pid");

CREATE TABLE IF NOT EXISTS "cy_class2"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class2"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class2"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class2"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class2"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class2"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class2"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class2"."remark" IS '注释';
COMMENT ON COLUMN "cy_class2"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class2_id_idx" ON "cy_class2" ("id");
CREATE INDEX "cy_class2_infonum_idx" ON "cy_class2" ("infonum");
ALTER TABLE "cy_class2" ADD CONSTRAINT "cy_class2_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class2_supid_idx" ON "cy_class2" ("pid");

CREATE TABLE IF NOT EXISTS "cy_class3"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class3"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class3"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class3"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class3"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class3"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class3"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class3"."remark" IS '注释';
COMMENT ON COLUMN "cy_class3"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class3_id_idx" ON "cy_class3" ("id");
CREATE INDEX "cy_class3_infonum_idx" ON "cy_class3" ("infonum");
ALTER TABLE "cy_class3" ADD CONSTRAINT "cy_class3_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class3_supid_idx" ON "cy_class3" ("pid");

CREATE TABLE IF NOT EXISTS "cy_class4"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class4"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class4"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class4"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class4"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class4"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class4"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class4"."remark" IS '注释';
COMMENT ON COLUMN "cy_class4"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class4_id_idx" ON "cy_class4" ("id");
CREATE INDEX "cy_class4_infonum_idx" ON "cy_class4" ("infonum");
ALTER TABLE "cy_class4" ADD CONSTRAINT "cy_class4_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class4_supid_idx" ON "cy_class4" ("pid");

CREATE TABLE IF NOT EXISTS "cy_class5"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class5"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class5"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class5"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class5"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class5"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class5"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class5"."remark" IS '注释';
COMMENT ON COLUMN "cy_class5"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class5_id_idx" ON "cy_class5" ("id");
CREATE INDEX "cy_class5_infonum_idx" ON "cy_class5" ("infonum");
ALTER TABLE "cy_class5" ADD CONSTRAINT "cy_class5_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class5_supid_idx" ON "cy_class5" ("pid");

CREATE TABLE IF NOT EXISTS "cy_class6"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class6"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class6"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class6"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class6"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class6"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class6"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class6"."remark" IS '注释';
COMMENT ON COLUMN "cy_class6"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class6_id_idx" ON "cy_class6" ("id");
CREATE INDEX "cy_class6_infonum_idx" ON "cy_class6" ("infonum");
ALTER TABLE "cy_class6" ADD CONSTRAINT "cy_class6_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class6_supid_idx" ON "cy_class6" ("pid");

CREATE TABLE IF NOT EXISTS "cy_countshop"
 (
	"id"			SERIAL, 
	"day"			TIMESTAMP WITHOUT TIME ZONE, 
	"times"			TIMESTAMP WITHOUT TIME ZONE, 
	"ip"			VARCHAR (50), 
	"where"			TEXT, 
	"info"			TEXT
);
COMMENT ON COLUMN "cy_countshop"."ip" IS '用户IP地址';

-- CREATE INDEXES ...
CREATE INDEX "cy_countshop_id_idx" ON "cy_countshop" ("id");

CREATE TABLE IF NOT EXISTS "cy_counttotal"
 (
	"zzday"			TIMESTAMP WITHOUT TIME ZONE, 
	"total"			INTEGER, 
	"yesterday"			INTEGER, 
	"today"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_counttotal_zzday_idx" ON "cy_counttotal" ("zzday");

CREATE TABLE IF NOT EXISTS "cy_down"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (50), 
	"remark"			TEXT, 
	"downurl"			VARCHAR (50), 
	"bpage"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"type"			INTEGER, 
	"uid"			VARCHAR (50)
);

-- CREATE INDEXES ...
CREATE INDEX "cy_down_id_idx" ON "cy_down" ("id");
ALTER TABLE "cy_down" ADD CONSTRAINT "cy_down_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_down_uid_idx" ON "cy_down" ("uid");

CREATE TABLE IF NOT EXISTS "cy_faq"
 (
	"id"			SERIAL, 
	"uid"			INTEGER, 
	"atype"			INTEGER, 
	"title"			VARCHAR (255), 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"gid"			INTEGER, 
	"stop"			INTEGER, 
	"goodid"			INTEGER, 
	"integral"			INTEGER, 
	"stoptime"			INTEGER, 
	"edittime"			VARCHAR (255)
);
COMMENT ON COLUMN "cy_faq"."uid" IS '用户ID';
COMMENT ON COLUMN "cy_faq"."atype" IS '问题类型:0 宝宝 1 妈妈';
COMMENT ON COLUMN "cy_faq"."title" IS '问题标题';
COMMENT ON COLUMN "cy_faq"."remark" IS '问题内容';
COMMENT ON COLUMN "cy_faq"."hits" IS '点击';
COMMENT ON COLUMN "cy_faq"."gid" IS '题目ID';
COMMENT ON COLUMN "cy_faq"."stop" IS '已解决';
COMMENT ON COLUMN "cy_faq"."goodid" IS '最佳答案';
COMMENT ON COLUMN "cy_faq"."integral" IS '悬赏积分';
COMMENT ON COLUMN "cy_faq"."stoptime" IS '结束天数';
COMMENT ON COLUMN "cy_faq"."edittime" IS '编辑时间';

-- CREATE INDEXES ...
CREATE INDEX "cy_faq_gid_idx" ON "cy_faq" ("gid");
CREATE INDEX "cy_faq_goodid_idx" ON "cy_faq" ("goodid");
CREATE INDEX "cy_faq_id_idx" ON "cy_faq" ("id");
ALTER TABLE "cy_faq" ADD CONSTRAINT "cy_faq_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_faq_uid_idx" ON "cy_faq" ("uid");

CREATE TABLE IF NOT EXISTS "cy_feedback"
 (
	"id"			SERIAL, 
	"uname"			VARCHAR (50), 
	"upwd"			VARCHAR (50), 
	"cataname"			TEXT, 
	"username"			TEXT, 
	"tel"			TEXT, 
	"email"			TEXT, 
	"web"			TEXT, 
	"fax"			TEXT, 
	"address"			TEXT, 
	"title"			TEXT, 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"reply"			TEXT, 
	"retime"			TIMESTAMP WITHOUT TIME ZONE, 
	"lang"			TEXT, 
	"iskey"			INTEGER, 
	"qq"			TEXT, 
	"uid"			INTEGER, 
	"like"			TEXT, 
	"mianji"			TEXT, 
	"huxing"			TEXT, 
	"mudi"			TEXT, 
	"laiyuan"			TEXT, 
	"utype"			INTEGER, 
	"class_id"			INTEGER
);
COMMENT ON COLUMN "cy_feedback"."uname" IS '用户名';
COMMENT ON COLUMN "cy_feedback"."upwd" IS '密　码';
COMMENT ON COLUMN "cy_feedback"."cataname" IS '填表单位';
COMMENT ON COLUMN "cy_feedback"."username" IS '姓　名';
COMMENT ON COLUMN "cy_feedback"."tel" IS '性　别';
COMMENT ON COLUMN "cy_feedback"."email" IS '出生年月';
COMMENT ON COLUMN "cy_feedback"."web" IS '职　务';
COMMENT ON COLUMN "cy_feedback"."fax" IS '政治面貌';
COMMENT ON COLUMN "cy_feedback"."address" IS '身份证号码';
COMMENT ON COLUMN "cy_feedback"."title" IS '任职意向';
COMMENT ON COLUMN "cy_feedback"."remark" IS '工作单位';
COMMENT ON COLUMN "cy_feedback"."reply" IS '备注';
COMMENT ON COLUMN "cy_feedback"."mianji" IS '密码提示问题';
COMMENT ON COLUMN "cy_feedback"."huxing" IS '提示问题的答案';
COMMENT ON COLUMN "cy_feedback"."mudi" IS '个人简历';
COMMENT ON COLUMN "cy_feedback"."laiyuan" IS '工作简历';
COMMENT ON COLUMN "cy_feedback"."utype" IS '0、未审核,1、普通会员';

-- CREATE INDEXES ...
CREATE INDEX "cy_feedback_class_id_idx" ON "cy_feedback" ("class_id");
CREATE INDEX "cy_feedback_id_idx" ON "cy_feedback" ("id");
CREATE INDEX "cy_feedback_iskey_idx" ON "cy_feedback" ("iskey");
ALTER TABLE "cy_feedback" ADD CONSTRAINT "cy_feedback_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_feedback_uid_idx" ON "cy_feedback" ("username");
CREATE INDEX "cy_feedback_uid1_idx" ON "cy_feedback" ("uid");

CREATE TABLE IF NOT EXISTS "cy_feedback1"
 (
	"id"			SERIAL, 
	"pid"			INTEGER, 
	"uid"			VARCHAR (50), 
	"title"			VARCHAR (100), 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"reply"			INTEGER, 
	"retime"			TIMESTAMP WITHOUT TIME ZONE, 
	"iskey"			INTEGER, 
	"cd"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_feedback1_id_idx" ON "cy_feedback1" ("id");
CREATE INDEX "cy_feedback1_iskey_idx" ON "cy_feedback1" ("iskey");
CREATE INDEX "cy_feedback1_pid_idx" ON "cy_feedback1" ("pid");
ALTER TABLE "cy_feedback1" ADD CONSTRAINT "cy_feedback1_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_feedback1_uid_idx" ON "cy_feedback1" ("uid");

CREATE TABLE IF NOT EXISTS "cy_feedbackclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_feedbackclass_id_idx" ON "cy_feedbackclass" ("id");
CREATE INDEX "cy_feedbackclass_infonum_idx" ON "cy_feedbackclass" ("infonum");
ALTER TABLE "cy_feedbackclass" ADD CONSTRAINT "cy_feedbackclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_feedbackclass_supid_idx" ON "cy_feedbackclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_file"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"num"			VARCHAR (50), 
	"content"			TEXT, 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"pic"			VARCHAR (150), 
	"picsmall"			VARCHAR (150), 
	"price"			REAL, 
	"price1"			REAL, 
	"psize"			VARCHAR (50), 
	"weight"			VARCHAR (50), 
	"packing"			VARCHAR (50), 
	"pno"			VARCHAR (50), 
	"ccid"			INTEGER, 
	"atype"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_file_ccid_idx" ON "cy_file" ("ccid");
CREATE INDEX "cy_file_class_id_idx" ON "cy_file" ("class_id");
CREATE INDEX "cy_file_id_idx" ON "cy_file" ("id");
CREATE INDEX "cy_file_num_idx" ON "cy_file" ("num");
ALTER TABLE "cy_file" ADD CONSTRAINT "cy_file_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_game"
 (
	"id"			SERIAL, 
	"uid"			VARCHAR (50), 
	"name"			VARCHAR (50), 
	"url"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"remark"			TEXT, 
	"key"			INTEGER, 
	"swf_height"			INTEGER, 
	"swf_width"			INTEGER, 
	"pic"			VARCHAR (100)
);

-- CREATE INDEXES ...
CREATE INDEX "cy_game_id_idx" ON "cy_game" ("id");
CREATE INDEX "cy_game_key_idx" ON "cy_game" ("key");
ALTER TABLE "cy_game" ADD CONSTRAINT "cy_game_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_game_uid_idx" ON "cy_game" ("uid");

CREATE TABLE IF NOT EXISTS "cy_hdgg"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"product"			VARCHAR (50), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"did"			NUMERIC(15,2), 
	"kw"			VARCHAR (50), 
	"dw"			TEXT, 
	"k1"			TEXT, 
	"k2"			TEXT, 
	"k3"			TEXT, 
	"k4"			TEXT, 
	"hot"			INTEGER, 
	"k5"			TEXT, 
	"k6"			TEXT
);
COMMENT ON COLUMN "cy_hdgg"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_hdgg_class_id_idx" ON "cy_hdgg" ("class_id");
CREATE INDEX "cy_hdgg_did_idx" ON "cy_hdgg" ("did");
CREATE INDEX "cy_hdgg_id_idx" ON "cy_hdgg" ("id");
ALTER TABLE "cy_hdgg" ADD CONSTRAINT "cy_hdgg_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_hdgg2"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			TEXT, 
	"class_id"			INTEGER, 
	"product"			TEXT, 
	"content"			INTEGER
);
COMMENT ON COLUMN "cy_hdgg2"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_hdgg2_class_id_idx" ON "cy_hdgg2" ("class_id");
CREATE INDEX "cy_hdgg2_id_idx" ON "cy_hdgg2" ("id");
ALTER TABLE "cy_hdgg2" ADD CONSTRAINT "cy_hdgg2_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_hdggclass"
 (
	"id"			SERIAL, 
	"classname"			TEXT, 
	"eclassname"			TEXT, 
	"content"			TEXT, 
	"econtent"			TEXT, 
	"form_product"			VARCHAR (50), 
	"form_smallproduct"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_hdggclass"."id" IS '分类IDxl';
COMMENT ON COLUMN "cy_hdggclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_hdggclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_hdggclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_hdggclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_hdggclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_hdggclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_hdggclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_hdggclass_id_idx" ON "cy_hdggclass" ("id");
CREATE INDEX "cy_hdggclass_infonum_idx" ON "cy_hdggclass" ("infonum");
ALTER TABLE "cy_hdggclass" ADD CONSTRAINT "cy_hdggclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_hdggclass_supid_idx" ON "cy_hdggclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_hdggclass2"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_hdggclass2"."id" IS '分类ID';
COMMENT ON COLUMN "cy_hdggclass2"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_hdggclass2"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_hdggclass2"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_hdggclass2"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_hdggclass2"."img" IS '分类图片';
COMMENT ON COLUMN "cy_hdggclass2"."remark" IS '注释';
COMMENT ON COLUMN "cy_hdggclass2"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_hdggclass2_id_idx" ON "cy_hdggclass2" ("id");
CREATE INDEX "cy_hdggclass2_infonum_idx" ON "cy_hdggclass2" ("infonum");
ALTER TABLE "cy_hdggclass2" ADD CONSTRAINT "cy_hdggclass2_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_hdggclass2_supid_idx" ON "cy_hdggclass2" ("pid");

CREATE TABLE IF NOT EXISTS "cy_hdtp"
 (
	"id"			SERIAL, 
	"title"			TEXT, 
	"code"			INTEGER, 
	"page"			VARCHAR (50), 
	"bpage"			TEXT, 
	"j1"			TEXT, 
	"j2"			TEXT, 
	"u1"			TEXT, 
	"u2"			TEXT, 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"cd"			INTEGER, 
	"jb"			TEXT, 
	"gg"			TEXT, 
	"nf"			TEXT, 
	"zl"			TEXT, 
	"wg"			TEXT, 
	"xj"			TEXT, 
	"kg"			TEXT, 
	"ch"			TEXT, 
	"nl"			TEXT, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"hot"			INTEGER, 
	"p1"			TEXT, 
	"p2"			TEXT, 
	"p3"			TEXT, 
	"p4"			TEXT
);
COMMENT ON COLUMN "cy_hdtp"."title" IS '名称';
COMMENT ON COLUMN "cy_hdtp"."code" IS '货号';
COMMENT ON COLUMN "cy_hdtp"."page" IS '小图';
COMMENT ON COLUMN "cy_hdtp"."bpage" IS '大图';
COMMENT ON COLUMN "cy_hdtp"."j1" IS '价格1';
COMMENT ON COLUMN "cy_hdtp"."j2" IS '价格2';
COMMENT ON COLUMN "cy_hdtp"."u1" IS '地址1';
COMMENT ON COLUMN "cy_hdtp"."u2" IS '地址2';
COMMENT ON COLUMN "cy_hdtp"."time" IS '添加日期';
COMMENT ON COLUMN "cy_hdtp"."hits" IS '排序';
COMMENT ON COLUMN "cy_hdtp"."cd" IS '新品推荐';
COMMENT ON COLUMN "cy_hdtp"."jb" IS '男女款';
COMMENT ON COLUMN "cy_hdtp"."gg" IS '风格';
COMMENT ON COLUMN "cy_hdtp"."nf" IS '款式';
COMMENT ON COLUMN "cy_hdtp"."zl" IS '硬度';
COMMENT ON COLUMN "cy_hdtp"."wg" IS '质地';
COMMENT ON COLUMN "cy_hdtp"."xj" IS '价格区间';
COMMENT ON COLUMN "cy_hdtp"."kg" IS '成色';
COMMENT ON COLUMN "cy_hdtp"."ch" IS '英文备注';
COMMENT ON COLUMN "cy_hdtp"."nl" IS '年龄';
COMMENT ON COLUMN "cy_hdtp"."user" IS '添加人员';
COMMENT ON COLUMN "cy_hdtp"."class_id" IS '分类ID';
COMMENT ON COLUMN "cy_hdtp"."hot" IS '热卖';

-- CREATE INDEXES ...
CREATE INDEX "cy_hdtp_class_id_idx" ON "cy_hdtp" ("class_id");
CREATE INDEX "cy_hdtp_form_code_idx" ON "cy_hdtp" ("code");
CREATE INDEX "cy_hdtp_id_idx" ON "cy_hdtp" ("id");
ALTER TABLE "cy_hdtp" ADD CONSTRAINT "cy_hdtp_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_hdtpclass"
 (
	"id"			SERIAL, 
	"classname"			TEXT, 
	"eclassname"			TEXT, 
	"content"			TEXT, 
	"econtent"			TEXT, 
	"form_product"			VARCHAR (50), 
	"form_smallproduct"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_hdtpclass"."id" IS '分类IDxl';
COMMENT ON COLUMN "cy_hdtpclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_hdtpclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_hdtpclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_hdtpclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_hdtpclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_hdtpclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_hdtpclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_hdtpclass_id_idx" ON "cy_hdtpclass" ("id");
CREATE INDEX "cy_hdtpclass_infonum_idx" ON "cy_hdtpclass" ("infonum");
ALTER TABLE "cy_hdtpclass" ADD CONSTRAINT "cy_hdtpclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_hdtpclass_supid_idx" ON "cy_hdtpclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_hltz"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			TEXT, 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			TEXT, 
	"class_id"			INTEGER, 
	"tt"			TEXT, 
	"kw"			TEXT, 
	"ds"			TEXT, 
	"img"			TEXT
);
COMMENT ON COLUMN "cy_hltz"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_hltz_class_id_idx" ON "cy_hltz" ("class_id");
CREATE INDEX "cy_hltz_id_idx" ON "cy_hltz" ("id");
CREATE INDEX "cy_hltz_keys_idx" ON "cy_hltz" ("kw");
ALTER TABLE "cy_hltz" ADD CONSTRAINT "cy_hltz_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_job"
 (
	"id"			SERIAL, 
	"name"			VARCHAR (50), 
	"sort"			VARCHAR (20), 
	"specialty"			VARCHAR (50), 
	"s_sort"			VARCHAR (20), 
	"place"			VARCHAR (20), 
	"kind"			VARCHAR (10), 
	"num"			INTEGER, 
	"sex"			VARCHAR (2), 
	"edu"			VARCHAR (10), 
	"remark"			TEXT, 
	"pay"			VARCHAR (50), 
	"pay2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"uid"			VARCHAR (20), 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"date"			VARCHAR (50), 
	"age"			VARCHAR (50), 
	"age1"			TEXT, 
	"object"			INTEGER
);
COMMENT ON COLUMN "cy_job"."name" IS '招聘职位';
COMMENT ON COLUMN "cy_job"."sort" IS '职位类别';
COMMENT ON COLUMN "cy_job"."specialty" IS '专业要求';
COMMENT ON COLUMN "cy_job"."s_sort" IS '专业类别';
COMMENT ON COLUMN "cy_job"."place" IS '工作地点';
COMMENT ON COLUMN "cy_job"."kind" IS '工作性质';
COMMENT ON COLUMN "cy_job"."num" IS '招聘人数';
COMMENT ON COLUMN "cy_job"."sex" IS '性别';
COMMENT ON COLUMN "cy_job"."edu" IS '学历要求';
COMMENT ON COLUMN "cy_job"."remark" IS '其他要求';
COMMENT ON COLUMN "cy_job"."pay" IS '参考月薪';
COMMENT ON COLUMN "cy_job"."pay2" IS '其他待遇';
COMMENT ON COLUMN "cy_job"."time" IS '发布时间';
COMMENT ON COLUMN "cy_job"."hits" IS '点击';
COMMENT ON COLUMN "cy_job"."uid" IS '发布者';
COMMENT ON COLUMN "cy_job"."date" IS '有效期';
COMMENT ON COLUMN "cy_job"."age" IS '年龄要求';
COMMENT ON COLUMN "cy_job"."age1" IS '年龄要求';
COMMENT ON COLUMN "cy_job"."object" IS '招聘对象';

-- CREATE INDEXES ...
CREATE INDEX "cy_job_num_idx" ON "cy_job" ("num");
ALTER TABLE "cy_job" ADD CONSTRAINT "cy_job_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_job_uid_idx" ON "cy_job" ("uid");

CREATE TABLE IF NOT EXISTS "cy_jobs"
 (
	"id"			SERIAL, 
	"name"			VARCHAR (50), 
	"sex"			INTEGER, 
	"birthday"			VARCHAR (50), 
	"email"			VARCHAR (100), 
	"oicq"			VARCHAR (50), 
	"msn"			VARCHAR (50), 
	"address"			VARCHAR (50), 
	"tel"			VARCHAR (50), 
	"mobile"			VARCHAR (50), 
	"school"			VARCHAR (50), 
	"gradyear"			VARCHAR (50), 
	"jobid"			INTEGER, 
	"ability"			TEXT, 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"iskey"			INTEGER
);
COMMENT ON COLUMN "cy_jobs"."name" IS '姓名';
COMMENT ON COLUMN "cy_jobs"."oicq" IS '学历';
COMMENT ON COLUMN "cy_jobs"."msn" IS '专业';
COMMENT ON COLUMN "cy_jobs"."address" IS '地址';
COMMENT ON COLUMN "cy_jobs"."tel" IS '电话';
COMMENT ON COLUMN "cy_jobs"."mobile" IS '经验';
COMMENT ON COLUMN "cy_jobs"."jobid" IS '应聘岗位ID';
COMMENT ON COLUMN "cy_jobs"."remark" IS '备注';
COMMENT ON COLUMN "cy_jobs"."time" IS '加入时间';

-- CREATE INDEXES ...
CREATE INDEX "cy_jobs_id_idx" ON "cy_jobs" ("id");
CREATE INDEX "cy_jobs_iskey_idx" ON "cy_jobs" ("iskey");
CREATE INDEX "cy_jobs_jobid_idx" ON "cy_jobs" ("jobid");
ALTER TABLE "cy_jobs" ADD CONSTRAINT "cy_jobs_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_link"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (50), 
	"remark"			VARCHAR (255), 
	"url"			VARCHAR (100), 
	"logo"			VARCHAR (100), 
	"linktype"			INTEGER, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"pass"			VARCHAR (32), 
	"show"			INTEGER, 
	"key"			INTEGER, 
	"logo_height"			INTEGER, 
	"logo_width"			INTEGER
);
COMMENT ON COLUMN "cy_link"."title" IS '网站名称';
COMMENT ON COLUMN "cy_link"."remark" IS '网站简介';
COMMENT ON COLUMN "cy_link"."url" IS '网址';
COMMENT ON COLUMN "cy_link"."logo" IS 'logo地址';
COMMENT ON COLUMN "cy_link"."linktype" IS '链接类型';
COMMENT ON COLUMN "cy_link"."time" IS '时间';
COMMENT ON COLUMN "cy_link"."hits" IS '点击次数';
COMMENT ON COLUMN "cy_link"."pass" IS '密码(修改链接用)';
COMMENT ON COLUMN "cy_link"."show" IS '首页显示';
COMMENT ON COLUMN "cy_link"."key" IS '审核';

-- CREATE INDEXES ...
CREATE INDEX "cy_link_id_idx" ON "cy_link" ("id");
CREATE INDEX "cy_link_key_idx" ON "cy_link" ("key");
ALTER TABLE "cy_link" ADD CONSTRAINT "cy_link_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_log"
 (
	"id"			SERIAL, 
	"uid"			INTEGER, 
	"log"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"ip"			VARCHAR (15)
);
COMMENT ON COLUMN "cy_log"."uid" IS '操作者 ID';
COMMENT ON COLUMN "cy_log"."log" IS '事件';
COMMENT ON COLUMN "cy_log"."time" IS '时间';
COMMENT ON COLUMN "cy_log"."ip" IS 'IP记录';

-- CREATE INDEXES ...
CREATE INDEX "cy_log_id_idx" ON "cy_log" ("id");
ALTER TABLE "cy_log" ADD CONSTRAINT "cy_log_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_magazine"
 (
	"id"			SERIAL, 
	"uid"			VARCHAR (20), 
	"name"			VARCHAR (50), 
	"pic"			VARCHAR (50), 
	"url"			VARCHAR (100), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_magazine_id_idx" ON "cy_magazine" ("id");
ALTER TABLE "cy_magazine" ADD CONSTRAINT "cy_magazine_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_magazine_uid_idx" ON "cy_magazine" ("uid");

CREATE TABLE IF NOT EXISTS "cy_news"
 (
	"id"			SERIAL, 
	"title"			TEXT, 
	"page"			VARCHAR (50), 
	"keys"			TEXT, 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			VARCHAR (50), 
	"btype"			INTEGER
);
COMMENT ON COLUMN "cy_news"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news_class_id_idx" ON "cy_news" ("class_id");
CREATE INDEX "cy_news_id_idx" ON "cy_news" ("id");
CREATE INDEX "cy_news_key_idx" ON "cy_news" ("keys");
ALTER TABLE "cy_news" ADD CONSTRAINT "cy_news_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_news1"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			INTEGER, 
	"btype"			INTEGER
);
COMMENT ON COLUMN "cy_news1"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news1_class_id_idx" ON "cy_news1" ("class_id");
CREATE INDEX "cy_news1_id_idx" ON "cy_news1" ("id");
ALTER TABLE "cy_news1" ADD CONSTRAINT "cy_news1_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_news2"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			INTEGER, 
	"btype"			INTEGER
);
COMMENT ON COLUMN "cy_news2"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news2_class_id_idx" ON "cy_news2" ("class_id");
CREATE INDEX "cy_news2_id_idx" ON "cy_news2" ("id");
ALTER TABLE "cy_news2" ADD CONSTRAINT "cy_news2_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_news3"
 (
	"id"			SERIAL, 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			INTEGER, 
	"btype"			INTEGER, 
	"title"			TEXT, 
	"title2"			TEXT
);
COMMENT ON COLUMN "cy_news3"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news3_class_id_idx" ON "cy_news3" ("class_id");
CREATE INDEX "cy_news3_id_idx" ON "cy_news3" ("id");
ALTER TABLE "cy_news3" ADD CONSTRAINT "cy_news3_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_news4"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			INTEGER, 
	"btype"			INTEGER, 
	"prices"			NUMERIC(15,2), 
	"k1"			TEXT, 
	"k2"			TEXT, 
	"k3"			TEXT, 
	"k4"			TEXT
);
COMMENT ON COLUMN "cy_news4"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news4_class_id_idx" ON "cy_news4" ("class_id");
CREATE INDEX "cy_news4_id_idx" ON "cy_news4" ("id");
ALTER TABLE "cy_news4" ADD CONSTRAINT "cy_news4_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_news5"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			INTEGER, 
	"btype"			INTEGER, 
	"prices"			NUMERIC(15,2), 
	"k1"			TEXT, 
	"k2"			TEXT, 
	"k3"			TEXT, 
	"k4"			TEXT
);
COMMENT ON COLUMN "cy_news5"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news5_class_id_idx" ON "cy_news5" ("class_id");
CREATE INDEX "cy_news5_id_idx" ON "cy_news5" ("id");
ALTER TABLE "cy_news5" ADD CONSTRAINT "cy_news5_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_news6"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"content2"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER, 
	"bdate"			TIMESTAMP WITHOUT TIME ZONE, 
	"bcount"			INTEGER, 
	"btype"			INTEGER, 
	"prices"			NUMERIC(15,2), 
	"k1"			TEXT, 
	"k2"			TEXT, 
	"k3"			TEXT, 
	"k4"			TEXT
);
COMMENT ON COLUMN "cy_news6"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_news6_class_id_idx" ON "cy_news6" ("class_id");
CREATE INDEX "cy_news6_id_idx" ON "cy_news6" ("id");
ALTER TABLE "cy_news6" ADD CONSTRAINT "cy_news6_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_photobox"
 (
	"id"			SERIAL, 
	"path"			VARCHAR (50), 
	"db"			VARCHAR (50), 
	"pid"			INTEGER, 
	"title"			VARCHAR (50)
);

-- CREATE INDEXES ...
CREATE INDEX "cy_photobox_dbid_idx" ON "cy_photobox" ("pid");
CREATE INDEX "cy_photobox_id_idx" ON "cy_photobox" ("id");
ALTER TABLE "cy_photobox" ADD CONSTRAINT "cy_photobox_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_product"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"num"			VARCHAR (50), 
	"content"			TEXT, 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"pic"			VARCHAR (150), 
	"picsmall"			VARCHAR (150), 
	"price"			TEXT, 
	"price1"			REAL, 
	"psize"			TEXT, 
	"weight"			VARCHAR (50), 
	"packing"			VARCHAR (50), 
	"pno"			VARCHAR (50), 
	"ccid"			INTEGER, 
	"content2"			TEXT, 
	"content3"			TEXT, 
	"content4"			TEXT
);
COMMENT ON COLUMN "cy_product"."content" IS '简介';
COMMENT ON COLUMN "cy_product"."remark" IS '介绍';
COMMENT ON COLUMN "cy_product"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_product_ccid_idx" ON "cy_product" ("ccid");
CREATE INDEX "cy_product_class_id_idx" ON "cy_product" ("class_id");
CREATE INDEX "cy_product_id_idx" ON "cy_product" ("id");
CREATE INDEX "cy_product_num_idx" ON "cy_product" ("num");
ALTER TABLE "cy_product" ADD CONSTRAINT "cy_product_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_productclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"content"			TEXT
);
COMMENT ON COLUMN "cy_productclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_productclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_productclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_productclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_productclass"."img" IS '分类图片';

-- CREATE INDEXES ...
CREATE INDEX "cy_productclass_id_idx" ON "cy_productclass" ("id");
ALTER TABLE "cy_productclass" ADD CONSTRAINT "cy_productclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_productclass_supid_idx" ON "cy_productclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_productsclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150)
);
COMMENT ON COLUMN "cy_productsclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_productsclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_productsclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_productsclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_productsclass"."img" IS '分类图片';

-- CREATE INDEXES ...
CREATE INDEX "cy_productsclass_id_idx" ON "cy_productsclass" ("id");
ALTER TABLE "cy_productsclass" ADD CONSTRAINT "cy_productsclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_productsclass_supid_idx" ON "cy_productsclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_qq"
 (
	"id"			SERIAL, 
	"qqnum"			VARCHAR (15), 
	"name"			VARCHAR (50), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"pic"			INTEGER, 
	"online"			VARCHAR (50), 
	"offline"			VARCHAR (50), 
	"group_id"			INTEGER, 
	"onlinekey"			INTEGER, 
	"paixu"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_qq_group_id_idx" ON "cy_qq" ("group_id");
CREATE INDEX "cy_qq_id_idx" ON "cy_qq" ("id");
CREATE INDEX "cy_qq_onlinekey_idx" ON "cy_qq" ("onlinekey");
ALTER TABLE "cy_qq" ADD CONSTRAINT "cy_qq_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_qq_qqnum_idx" ON "cy_qq" ("qqnum");

CREATE TABLE IF NOT EXISTS "cy_qqclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"remark"			VARCHAR (255), 
	"paixu"			INTEGER, 
	"time"			TIMESTAMP WITHOUT TIME ZONE
);

-- CREATE INDEXES ...
CREATE INDEX "cy_qqclass_id_idx" ON "cy_qqclass" ("id");
ALTER TABLE "cy_qqclass" ADD CONSTRAINT "cy_qqclass_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_sp"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"url"			VARCHAR (50)
);
COMMENT ON COLUMN "cy_sp"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_sp_class_id_idx" ON "cy_sp" ("class_id");
CREATE INDEX "cy_sp_id_idx" ON "cy_sp" ("id");
ALTER TABLE "cy_sp" ADD CONSTRAINT "cy_sp_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_spclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_spclass"."id" IS '分类ID';
COMMENT ON COLUMN "cy_spclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_spclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_spclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_spclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_spclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_spclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_spclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_spclass_id_idx" ON "cy_spclass" ("id");
CREATE INDEX "cy_spclass_infonum_idx" ON "cy_spclass" ("infonum");
ALTER TABLE "cy_spclass" ADD CONSTRAINT "cy_spclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_spclass_supid_idx" ON "cy_spclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_tishi"
 (
	"id"			SERIAL, 
	"qqnum"			VARCHAR (15), 
	"name"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"pic"			INTEGER, 
	"online"			TEXT, 
	"offline"			TEXT, 
	"group_id"			INTEGER, 
	"onlinekey"			INTEGER, 
	"paixu"			INTEGER, 
	"class_id"			INTEGER, 
	"geci"			TEXT, 
	"users"			VARCHAR (50), 
	"admin"			VARCHAR (50)
);

-- CREATE INDEXES ...
CREATE INDEX "cy_tishi_class_id_idx" ON "cy_tishi" ("class_id");
CREATE INDEX "cy_tishi_group_id_idx" ON "cy_tishi" ("group_id");
CREATE INDEX "cy_tishi_id_idx" ON "cy_tishi" ("id");
CREATE INDEX "cy_tishi_onlinekey_idx" ON "cy_tishi" ("onlinekey");
ALTER TABLE "cy_tishi" ADD CONSTRAINT "cy_tishi_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_tishi_qqnum_idx" ON "cy_tishi" ("qqnum");

CREATE TABLE IF NOT EXISTS "cy_tongzhi"
 (
	"id"			SERIAL, 
	"title"			TEXT, 
	"page"			TEXT, 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER
);
COMMENT ON COLUMN "cy_tongzhi"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_tongzhi_class_id_idx" ON "cy_tongzhi" ("class_id");
CREATE INDEX "cy_tongzhi_id_idx" ON "cy_tongzhi" ("id");
ALTER TABLE "cy_tongzhi" ADD CONSTRAINT "cy_tongzhi_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_tongzhiclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_tongzhiclass"."id" IS '分类ID';
COMMENT ON COLUMN "cy_tongzhiclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_tongzhiclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_tongzhiclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_tongzhiclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_tongzhiclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_tongzhiclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_tongzhiclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_tongzhiclass_id_idx" ON "cy_tongzhiclass" ("id");
CREATE INDEX "cy_tongzhiclass_infonum_idx" ON "cy_tongzhiclass" ("infonum");
ALTER TABLE "cy_tongzhiclass" ADD CONSTRAINT "cy_tongzhiclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_tongzhiclass_supid_idx" ON "cy_tongzhiclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_user"
 (
	"id"			SERIAL, 
	"username"			VARCHAR (16), 
	"pass"			VARCHAR (32), 
	"face"			VARCHAR (150), 
	"truename"			VARCHAR (15), 
	"sex"			INTEGER, 
	"age"			INTEGER, 
	"email"			VARCHAR (100), 
	"qq"			VARCHAR (12), 
	"web"			VARCHAR (100), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"lasttime"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"group_id"			INTEGER, 
	"ip"			VARCHAR (15), 
	"regip"			VARCHAR (15), 
	"key"			INTEGER, 
	"integral"			INTEGER, 
	"grade"			INTEGER, 
	"jobjoin"			TEXT, 
	"utype"			VARCHAR (50)
);
COMMENT ON COLUMN "cy_user"."username" IS '用户名';
COMMENT ON COLUMN "cy_user"."pass" IS '密码';
COMMENT ON COLUMN "cy_user"."face" IS '形象照';
COMMENT ON COLUMN "cy_user"."truename" IS '真实姓名';
COMMENT ON COLUMN "cy_user"."sex" IS '性别 0,女   1 男   2  密';
COMMENT ON COLUMN "cy_user"."age" IS '年龄';
COMMENT ON COLUMN "cy_user"."time" IS '注册时间';
COMMENT ON COLUMN "cy_user"."lasttime" IS '最后登陆时间';
COMMENT ON COLUMN "cy_user"."hits" IS '浏览次数';
COMMENT ON COLUMN "cy_user"."group_id" IS '用户组ID   1，普通用户，2，专家';
COMMENT ON COLUMN "cy_user"."ip" IS '最后登陆的Ip';
COMMENT ON COLUMN "cy_user"."regip" IS '注册IP';
COMMENT ON COLUMN "cy_user"."key" IS '审核';
COMMENT ON COLUMN "cy_user"."integral" IS '积分';
COMMENT ON COLUMN "cy_user"."grade" IS '等级';
COMMENT ON COLUMN "cy_user"."utype" IS '会员类型';

-- CREATE INDEXES ...
CREATE INDEX "cy_user_group_id_idx" ON "cy_user" ("group_id");
CREATE INDEX "cy_user_id_idx" ON "cy_user" ("id");
CREATE INDEX "cy_user_key_idx" ON "cy_user" ("key");
ALTER TABLE "cy_user" ADD CONSTRAINT "cy_user_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_userbal"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"e_title"			VARCHAR (50), 
	"content"			TEXT, 
	"e_content"			VARCHAR (50), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"form_smallproduct"			VARCHAR (50), 
	"smallwall"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER
);
COMMENT ON COLUMN "cy_userbal"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_userbal_class_id_idx" ON "cy_userbal" ("class_id");
CREATE INDEX "cy_userbal_id_idx" ON "cy_userbal" ("id");
ALTER TABLE "cy_userbal" ADD CONSTRAINT "cy_userbal_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_userbal_class"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_userbal_class"."id" IS '分类ID';
COMMENT ON COLUMN "cy_userbal_class"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_userbal_class"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_userbal_class"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_userbal_class"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_userbal_class"."img" IS '分类图片';
COMMENT ON COLUMN "cy_userbal_class"."remark" IS '注释';
COMMENT ON COLUMN "cy_userbal_class"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_userbal_class_id_idx" ON "cy_userbal_class" ("id");
CREATE INDEX "cy_userbal_class_infonum_idx" ON "cy_userbal_class" ("infonum");
ALTER TABLE "cy_userbal_class" ADD CONSTRAINT "cy_userbal_class_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_userbal_class_supid_idx" ON "cy_userbal_class" ("pid");

CREATE TABLE IF NOT EXISTS "cy_vote"
 (
	"title"			VARCHAR (50), 
	"select1"			VARCHAR (50), 
	"answer1"			INTEGER, 
	"select2"			VARCHAR (50), 
	"answer2"			INTEGER, 
	"select3"			VARCHAR (50), 
	"answer3"			INTEGER, 
	"select4"			VARCHAR (50), 
	"answer4"			INTEGER, 
	"select5"			VARCHAR (50), 
	"answer5"			INTEGER, 
	"select6"			VARCHAR (50), 
	"answer6"			INTEGER, 
	"select7"			VARCHAR (50), 
	"answer7"			INTEGER, 
	"select8"			VARCHAR (50), 
	"answer8"			INTEGER, 
	"votetime"			TIMESTAMP WITHOUT TIME ZONE, 
	"votetype"			VARCHAR (10), 
	"view"			VARCHAR (1)
);
COMMENT ON COLUMN "cy_vote"."title" IS '调查的标题';
COMMENT ON COLUMN "cy_vote"."select1" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."answer1" IS '投票数';
COMMENT ON COLUMN "cy_vote"."select2" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."select3" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."select4" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."select5" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."select6" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."select7" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."select8" IS '第一选项';
COMMENT ON COLUMN "cy_vote"."votetime" IS '日期';
COMMENT ON COLUMN "cy_vote"."votetype" IS '单选或多选';
COMMENT ON COLUMN "cy_vote"."view" IS '是否显示';

-- CREATE INDEXES ...

CREATE TABLE IF NOT EXISTS "cy_webinfo"
 (
	"id"			SERIAL, 
	"name"			VARCHAR (50), 
	"website"			VARCHAR (100), 
	"area_id"			INTEGER, 
	"class_id"			VARCHAR (100), 
	"check"			INTEGER, 
	"vouch"			INTEGER, 
	"commark"			VARCHAR (255), 
	"content"			TEXT, 
	"address"			VARCHAR (50), 
	"joindate"			TIMESTAMP WITHOUT TIME ZONE, 
	"linkman"			VARCHAR (30), 
	"tel"			VARCHAR (50), 
	"fax"			VARCHAR (50), 
	"post"			INTEGER, 
	"mail"			VARCHAR (100), 
	"hits"			INTEGER
);
COMMENT ON COLUMN "cy_webinfo"."id" IS '商家ID';
COMMENT ON COLUMN "cy_webinfo"."name" IS '网站名称';
COMMENT ON COLUMN "cy_webinfo"."website" IS '网址';
COMMENT ON COLUMN "cy_webinfo"."area_id" IS '地区名称';
COMMENT ON COLUMN "cy_webinfo"."class_id" IS '分类';
COMMENT ON COLUMN "cy_webinfo"."check" IS '审核';
COMMENT ON COLUMN "cy_webinfo"."vouch" IS '是否推荐';
COMMENT ON COLUMN "cy_webinfo"."commark" IS '公司品牌';
COMMENT ON COLUMN "cy_webinfo"."content" IS '公司简介';
COMMENT ON COLUMN "cy_webinfo"."address" IS '公司地址';
COMMENT ON COLUMN "cy_webinfo"."joindate" IS '加入时间';
COMMENT ON COLUMN "cy_webinfo"."linkman" IS '联系人';
COMMENT ON COLUMN "cy_webinfo"."tel" IS '电话';
COMMENT ON COLUMN "cy_webinfo"."fax" IS '传真';
COMMENT ON COLUMN "cy_webinfo"."post" IS '邮编';
COMMENT ON COLUMN "cy_webinfo"."mail" IS '邮箱';
COMMENT ON COLUMN "cy_webinfo"."hits" IS '点击数';

-- CREATE INDEXES ...
CREATE INDEX "cy_webinfo_area_id_idx" ON "cy_webinfo" ("area_id");
CREATE INDEX "cy_webinfo_class_id_idx" ON "cy_webinfo" ("class_id");
CREATE INDEX "cy_webinfo_id_idx" ON "cy_webinfo" ("id");
ALTER TABLE "cy_webinfo" ADD CONSTRAINT "cy_webinfo_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_wenhua"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER, 
	"px"			INTEGER
);
COMMENT ON COLUMN "cy_wenhua"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_wenhua_class_id_idx" ON "cy_wenhua" ("class_id");
CREATE INDEX "cy_wenhua_id_idx" ON "cy_wenhua" ("id");
ALTER TABLE "cy_wenhua" ADD CONSTRAINT "cy_wenhua_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_wenhuaclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_wenhuaclass"."id" IS '分类ID';
COMMENT ON COLUMN "cy_wenhuaclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_wenhuaclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_wenhuaclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_wenhuaclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_wenhuaclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_wenhuaclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_wenhuaclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_wenhuaclass_id_idx" ON "cy_wenhuaclass" ("id");
CREATE INDEX "cy_wenhuaclass_infonum_idx" ON "cy_wenhuaclass" ("infonum");
ALTER TABLE "cy_wenhuaclass" ADD CONSTRAINT "cy_wenhuaclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_wenhuaclass_supid_idx" ON "cy_wenhuaclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_xqxz"
 (
	"id"			SERIAL, 
	"name"			VARCHAR (50), 
	"sort"			VARCHAR (20), 
	"specialty"			VARCHAR (50), 
	"s_sort"			VARCHAR (20), 
	"object"			VARCHAR (10), 
	"place"			VARCHAR (20), 
	"kind"			VARCHAR (10), 
	"num"			INTEGER, 
	"date"			INTEGER, 
	"sex"			VARCHAR (2), 
	"edu"			VARCHAR (10), 
	"age"			INTEGER, 
	"age1"			INTEGER, 
	"remark"			TEXT, 
	"pay"			VARCHAR (50), 
	"pay2"			VARCHAR (255), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"uid"			VARCHAR (20)
);
COMMENT ON COLUMN "cy_xqxz"."name" IS '招聘职位';
COMMENT ON COLUMN "cy_xqxz"."sort" IS '职位类别';
COMMENT ON COLUMN "cy_xqxz"."specialty" IS '专业要求';
COMMENT ON COLUMN "cy_xqxz"."s_sort" IS '专业类别';
COMMENT ON COLUMN "cy_xqxz"."object" IS '招聘对象';
COMMENT ON COLUMN "cy_xqxz"."place" IS '工作地点';
COMMENT ON COLUMN "cy_xqxz"."kind" IS '工作性质';
COMMENT ON COLUMN "cy_xqxz"."num" IS '招聘人数';
COMMENT ON COLUMN "cy_xqxz"."date" IS '有效期';
COMMENT ON COLUMN "cy_xqxz"."sex" IS '性别';
COMMENT ON COLUMN "cy_xqxz"."edu" IS '学历要求';
COMMENT ON COLUMN "cy_xqxz"."age" IS '年龄要求';
COMMENT ON COLUMN "cy_xqxz"."age1" IS '年龄要求';
COMMENT ON COLUMN "cy_xqxz"."remark" IS '其他要求';
COMMENT ON COLUMN "cy_xqxz"."pay" IS '参考月薪';
COMMENT ON COLUMN "cy_xqxz"."pay2" IS '其他待遇';
COMMENT ON COLUMN "cy_xqxz"."time" IS '发布时间';
COMMENT ON COLUMN "cy_xqxz"."hits" IS '点击';
COMMENT ON COLUMN "cy_xqxz"."uid" IS '发布者';

-- CREATE INDEXES ...
CREATE INDEX "cy_xqxz_num_idx" ON "cy_xqxz" ("num");
ALTER TABLE "cy_xqxz" ADD CONSTRAINT "cy_xqxz_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_xqxz_uid_idx" ON "cy_xqxz" ("uid");

CREATE TABLE IF NOT EXISTS "cy_xqxz_users"
 (
	"id"			SERIAL, 
	"xid"			INTEGER, 
	"uname"			VARCHAR (50), 
	"type"			INTEGER, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"time2"			TIMESTAMP WITHOUT TIME ZONE
);
COMMENT ON COLUMN "cy_xqxz_users"."xid" IS '兴趣小组编号';
COMMENT ON COLUMN "cy_xqxz_users"."uname" IS '申请人';
COMMENT ON COLUMN "cy_xqxz_users"."type" IS '申请通过0,未通过,1通过';

-- CREATE INDEXES ...
CREATE INDEX "cy_xqxz_users_id_idx" ON "cy_xqxz_users" ("id");
ALTER TABLE "cy_xqxz_users" ADD CONSTRAINT "cy_xqxz_users_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_xqxz_users_uid_idx" ON "cy_xqxz_users" ("uname");
CREATE INDEX "cy_xqxz_users_xid_idx" ON "cy_xqxz_users" ("xid");

CREATE TABLE IF NOT EXISTS "cy_yxyg"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER
);
COMMENT ON COLUMN "cy_yxyg"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_yxyg_class_id_idx" ON "cy_yxyg" ("class_id");
CREATE INDEX "cy_yxyg_id_idx" ON "cy_yxyg" ("id");
ALTER TABLE "cy_yxyg" ADD CONSTRAINT "cy_yxyg_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_ztjq"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER
);
COMMENT ON COLUMN "cy_ztjq"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_ztjq_class_id_idx" ON "cy_ztjq" ("class_id");
CREATE INDEX "cy_ztjq_id_idx" ON "cy_ztjq" ("id");
ALTER TABLE "cy_ztjq" ADD CONSTRAINT "cy_ztjq_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_ztjqclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "cy_ztjqclass_id_idx" ON "cy_ztjqclass" ("id");
CREATE INDEX "cy_ztjqclass_infonum_idx" ON "cy_ztjqclass" ("infonum");
ALTER TABLE "cy_ztjqclass" ADD CONSTRAINT "cy_ztjqclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_ztjqclass_supid_idx" ON "cy_ztjqclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_zxdc"
 (
	"id"			SERIAL, 
	"name"			VARCHAR (50), 
	"pid"			INTEGER, 
	"cktype"			INTEGER, 
	"kg"			INTEGER, 
	"time"			TIMESTAMP WITHOUT TIME ZONE
);

-- CREATE INDEXES ...
CREATE INDEX "cy_zxdc_id_idx" ON "cy_zxdc" ("id");
CREATE INDEX "cy_zxdc_pid_idx" ON "cy_zxdc" ("pid");
ALTER TABLE "cy_zxdc" ADD CONSTRAINT "cy_zxdc_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_zxyy"
 (
	"id"			SERIAL, 
	"username"			VARCHAR (16), 
	"pass"			VARCHAR (32), 
	"face"			VARCHAR (150), 
	"truename"			VARCHAR (15), 
	"sex"			INTEGER, 
	"age"			INTEGER, 
	"email"			VARCHAR (100), 
	"qq"			VARCHAR (12), 
	"web"			VARCHAR (100), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"lasttime"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"group_id"			INTEGER, 
	"ip"			VARCHAR (15), 
	"regip"			VARCHAR (15), 
	"key"			INTEGER, 
	"integral"			INTEGER, 
	"grade"			INTEGER, 
	"jobjoin"			TEXT
);

-- CREATE INDEXES ...
CREATE INDEX "cy_zxyy_group_id_idx" ON "cy_zxyy" ("group_id");
CREATE INDEX "cy_zxyy_id_idx" ON "cy_zxyy" ("id");
CREATE INDEX "cy_zxyy_key_idx" ON "cy_zxyy" ("key");
ALTER TABLE "cy_zxyy" ADD CONSTRAINT "cy_zxyy_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "guestbook"
 (
	"id"			SERIAL, 
	"name"			VARCHAR (20), 
	"sex"			INTEGER, 
	"qq"			INTEGER, 
	"city"			VARCHAR (15), 
	"web"			VARCHAR (50), 
	"email"			VARCHAR (200), 
	"admin"			INTEGER, 
	"title"			VARCHAR (50), 
	"content"			TEXT, 
	"date"			TIMESTAMP WITHOUT TIME ZONE, 
	"ip"			VARCHAR (50), 
	"reply"			TEXT, 
	"ubbcode"			BOOLEAN NOT NULL, 
	"manage"			INTEGER, 
	"replytime"			TIMESTAMP WITHOUT TIME ZONE
);

-- CREATE INDEXES ...
ALTER TABLE "guestbook" ADD CONSTRAINT "guestbook_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "mast"
 (
	"mid"			SERIAL, 
	"mset"			TEXT
);

-- CREATE INDEXES ...
CREATE INDEX "mast_mid_idx" ON "mast" ("mid");

CREATE TABLE IF NOT EXISTS "cy_area"
 (
	"area_id"			SERIAL, 
	"area_name"			VARCHAR (50), 
	"paixu"			INTEGER
);
COMMENT ON COLUMN "cy_area"."area_id" IS '地区编号';
COMMENT ON COLUMN "cy_area"."area_name" IS '地区名称';
COMMENT ON COLUMN "cy_area"."paixu" IS '排序';

-- CREATE INDEXES ...
ALTER TABLE "cy_area" ADD CONSTRAINT "cy_area_pkey" PRIMARY KEY ("area_id");
CREATE INDEX "cy_area_zoneid_idx" ON "cy_area" ("area_id");

CREATE TABLE IF NOT EXISTS "cy_class1"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_class1"."id" IS '分类ID';
COMMENT ON COLUMN "cy_class1"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_class1"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_class1"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_class1"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_class1"."img" IS '分类图片';
COMMENT ON COLUMN "cy_class1"."remark" IS '注释';
COMMENT ON COLUMN "cy_class1"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_class1_id_idx" ON "cy_class1" ("id");
CREATE INDEX "cy_class1_infonum_idx" ON "cy_class1" ("infonum");
ALTER TABLE "cy_class1" ADD CONSTRAINT "cy_class1_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_class1_supid_idx" ON "cy_class1" ("pid");

CREATE TABLE IF NOT EXISTS "cy_countonline"
 (
	"id"			SERIAL, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"ip"			VARCHAR (50)
);
COMMENT ON COLUMN "cy_countonline"."ip" IS '用户IP地址';

-- CREATE INDEXES ...
CREATE INDEX "cy_countonline_id_idx" ON "cy_countonline" ("id");

CREATE TABLE IF NOT EXISTS "cy_feedback2"
 (
	"id"			SERIAL, 
	"cataname"			VARCHAR (50), 
	"username"			VARCHAR (20), 
	"tel"			VARCHAR (20), 
	"email"			VARCHAR (50), 
	"web"			VARCHAR (100), 
	"fax"			VARCHAR (50), 
	"address"			VARCHAR (50), 
	"title"			VARCHAR (50), 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"reply"			TEXT, 
	"retime"			TIMESTAMP WITHOUT TIME ZONE, 
	"lang"			VARCHAR (50), 
	"iskey"			INTEGER, 
	"qq"			VARCHAR (50), 
	"uid"			INTEGER, 
	"huxing"			VARCHAR (50), 
	"laiyuan"			VARCHAR (50), 
	"like"			TEXT, 
	"mianji"			TEXT, 
	"mudi"			VARCHAR (50)
);
COMMENT ON COLUMN "cy_feedback2"."lang" IS '语言';

-- CREATE INDEXES ...
CREATE INDEX "cy_feedback2_id_idx" ON "cy_feedback2" ("id");
CREATE INDEX "cy_feedback2_iskey_idx" ON "cy_feedback2" ("iskey");
ALTER TABLE "cy_feedback2" ADD CONSTRAINT "cy_feedback2_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_feedback2_uid_idx" ON "cy_feedback2" ("username");
CREATE INDEX "cy_feedback2_uid1_idx" ON "cy_feedback2" ("uid");

CREATE TABLE IF NOT EXISTS "cy_hltzclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_hltzclass"."id" IS '分类ID';
COMMENT ON COLUMN "cy_hltzclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_hltzclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_hltzclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_hltzclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_hltzclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_hltzclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_hltzclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_hltzclass_id_idx" ON "cy_hltzclass" ("id");
CREATE INDEX "cy_hltzclass_infonum_idx" ON "cy_hltzclass" ("infonum");
ALTER TABLE "cy_hltzclass" ADD CONSTRAINT "cy_hltzclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_hltzclass_supid_idx" ON "cy_hltzclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_photo"
 (
	"id"			SERIAL, 
	"uid"			INTEGER, 
	"photoname"			VARCHAR (50), 
	"photocontent"			TEXT, 
	"photosurl"			VARCHAR (150), 
	"photourl"			VARCHAR (150), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"key"			INTEGER
);
COMMENT ON COLUMN "cy_photo"."uid" IS '用户ID';
COMMENT ON COLUMN "cy_photo"."photoname" IS '相片名称';
COMMENT ON COLUMN "cy_photo"."photocontent" IS '相片介绍';
COMMENT ON COLUMN "cy_photo"."photosurl" IS '相片缩略图';
COMMENT ON COLUMN "cy_photo"."photourl" IS '相片图片';
COMMENT ON COLUMN "cy_photo"."time" IS '添加时间';
COMMENT ON COLUMN "cy_photo"."hits" IS '点击';
COMMENT ON COLUMN "cy_photo"."key" IS '审核';

-- CREATE INDEXES ...
CREATE INDEX "cy_photo_id_idx" ON "cy_photo" ("id");
CREATE INDEX "cy_photo_key_idx" ON "cy_photo" ("key");
ALTER TABLE "cy_photo" ADD CONSTRAINT "cy_photo_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_photo_uid_idx" ON "cy_photo" ("uid");

CREATE TABLE IF NOT EXISTS "cy_products"
 (
	"id"			SERIAL, 
	"uid"			VARCHAR (20), 
	"name"			VARCHAR (50), 
	"pic"			VARCHAR (50), 
	"product"			VARCHAR (50), 
	"url"			NUMERIC(15,2), 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"class_id"			INTEGER, 
	"add"			VARCHAR (50), 
	"k1"			TEXT, 
	"k2"			TEXT, 
	"k3"			TEXT, 
	"k4"			TEXT, 
	"k5"			TEXT, 
	"k6"			TEXT, 
	"k7"			TEXT, 
	"xxt"			VARCHAR (50)
);

-- CREATE INDEXES ...
CREATE INDEX "cy_products_class_id_idx" ON "cy_products" ("class_id");
CREATE INDEX "cy_products_classid_idx" ON "cy_products" ("xxt");
CREATE INDEX "cy_products_id_idx" ON "cy_products" ("id");
ALTER TABLE "cy_products" ADD CONSTRAINT "cy_products_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_products_uid_idx" ON "cy_products" ("uid");

CREATE TABLE IF NOT EXISTS "cy_tishiclass"
 (
	"id"			SERIAL, 
	"classname"			VARCHAR (50), 
	"uname"			VARCHAR (50), 
	"pid"			INTEGER, 
	"paixu"			INTEGER, 
	"classtype"			INTEGER, 
	"img"			VARCHAR (150), 
	"remark"			VARCHAR (50), 
	"infonum"			INTEGER
);
COMMENT ON COLUMN "cy_tishiclass"."id" IS '分类ID';
COMMENT ON COLUMN "cy_tishiclass"."classname" IS '分类名称';
COMMENT ON COLUMN "cy_tishiclass"."pid" IS '父级ID';
COMMENT ON COLUMN "cy_tishiclass"."paixu" IS '排序ID';
COMMENT ON COLUMN "cy_tishiclass"."classtype" IS '分类类型：0，分类下允许添加信息，1作为分类不允许添加信息';
COMMENT ON COLUMN "cy_tishiclass"."img" IS '分类图片';
COMMENT ON COLUMN "cy_tishiclass"."remark" IS '注释';
COMMENT ON COLUMN "cy_tishiclass"."infonum" IS '信息条数';

-- CREATE INDEXES ...
CREATE INDEX "cy_tishiclass_id_idx" ON "cy_tishiclass" ("id");
CREATE INDEX "cy_tishiclass_infonum_idx" ON "cy_tishiclass" ("infonum");
ALTER TABLE "cy_tishiclass" ADD CONSTRAINT "cy_tishiclass_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_tishiclass_supid_idx" ON "cy_tishiclass" ("pid");

CREATE TABLE IF NOT EXISTS "cy_wall"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (50), 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"picsmall"			VARCHAR (100), 
	"pic"			VARCHAR (100), 
	"uid"			INTEGER, 
	"hits"			INTEGER, 
	"pic1"			VARCHAR (100)
);

-- CREATE INDEXES ...
CREATE INDEX "cy_wall_id_idx" ON "cy_wall" ("id");
ALTER TABLE "cy_wall" ADD CONSTRAINT "cy_wall_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_wall_uid_idx" ON "cy_wall" ("uid");

CREATE TABLE IF NOT EXISTS "cy_yxtd"
 (
	"id"			SERIAL, 
	"title"			VARCHAR (255), 
	"page"			VARCHAR (50), 
	"vgn"			TEXT, 
	"content"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"hits"			INTEGER, 
	"user"			VARCHAR (50), 
	"class_id"			INTEGER
);
COMMENT ON COLUMN "cy_yxtd"."class_id" IS '分类ID';

-- CREATE INDEXES ...
CREATE INDEX "cy_yxtd_class_id_idx" ON "cy_yxtd" ("class_id");
CREATE INDEX "cy_yxtd_id_idx" ON "cy_yxtd" ("id");
ALTER TABLE "cy_yxtd" ADD CONSTRAINT "cy_yxtd_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "cy_config"
 (
	"tt"			TEXT, 
	"kw"			TEXT, 
	"de"			TEXT, 
	"co"			TEXT
);

-- CREATE INDEXES ...

CREATE TABLE IF NOT EXISTS "cy_feedback3"
 (
	"id"			SERIAL, 
	"cataname"			VARCHAR (50), 
	"username"			VARCHAR (20), 
	"tel"			VARCHAR (20), 
	"email"			VARCHAR (50), 
	"web"			VARCHAR (100), 
	"fax"			VARCHAR (50), 
	"address"			VARCHAR (50), 
	"title"			VARCHAR (50), 
	"remark"			TEXT, 
	"time"			TIMESTAMP WITHOUT TIME ZONE, 
	"reply"			TEXT, 
	"retime"			TIMESTAMP WITHOUT TIME ZONE, 
	"lang"			VARCHAR (50), 
	"iskey"			INTEGER, 
	"qq"			VARCHAR (50), 
	"uid"			INTEGER, 
	"like"			TEXT, 
	"mianji"			TEXT, 
	"huxing"			VARCHAR (50), 
	"mudi"			VARCHAR (50), 
	"laiyuan"			VARCHAR (50)
);
COMMENT ON COLUMN "cy_feedback3"."lang" IS '语言';

-- CREATE INDEXES ...
CREATE INDEX "cy_feedback3_id_idx" ON "cy_feedback3" ("id");
CREATE INDEX "cy_feedback3_iskey_idx" ON "cy_feedback3" ("iskey");
ALTER TABLE "cy_feedback3" ADD CONSTRAINT "cy_feedback3_pkey" PRIMARY KEY ("id");
CREATE INDEX "cy_feedback3_uid_idx" ON "cy_feedback3" ("username");
CREATE INDEX "cy_feedback3_uid1_idx" ON "cy_feedback3" ("uid");

CREATE TABLE IF NOT EXISTS "cy_news3_输出错误"
 (
	"错误"			VARCHAR (255), 
	"字段"			VARCHAR (255), 
	"行"			INTEGER
);

-- CREATE INDEXES ...

CREATE TABLE IF NOT EXISTS "cy_feedback2_输出错误"
 (
	"错误"			VARCHAR (255), 
	"字段"			VARCHAR (255), 
	"行"			INTEGER
);

-- CREATE INDEXES ...


-- CREATE Relationships ...
-- relationships are not implemented for postgres
