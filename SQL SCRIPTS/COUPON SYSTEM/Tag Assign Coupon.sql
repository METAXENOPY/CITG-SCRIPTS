USE TEST_cu_coupon

SELECT * FROM coupon WHERE coupon = 101542283

DECLARE @memberid VARCHAR(255) SET @memberid =  '62992' -- Member ID
DECLARE @coupca VARCHAR(255) SET @coupca = 'B' -- Coupon Catergory
DECLARE @coupon1 VARCHAR(255) SET @coupon1 = '101542283' -- Coupon Start
DECLARE @coupon2 VARCHAR(255) SET @coupon2 = '101542283' -- Coupon End
DECLARE @remark VARCHAR(255) SET @remark = 'TEST 1' -- Remarks
DECLARE @coupsta VARCHAR(255) SET @coupsta = 'D' -- Coupon Status Code
DECLARE @membername VARCHAR(255)
SELECT @membername = v_name FROM coupon WHERE v_member_id = @memberid


UPDATE coupon
SET v_member_id = @memberid,
v_name = @membername,
remarks = @remark,
coupstat = @coupsta,
ludatetime = GETDATE()
WHERE coupon >= @coupon1 AND coupon <= @coupon2 AND
coupcat = @coupca AND
v_member_id = @memberid
GO