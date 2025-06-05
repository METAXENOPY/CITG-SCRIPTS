use cu_coupon
go



--Genmode = 0 if you want to disable pcheckkey and if its 0 prnstatus = N
SELECT * FROM coupon WHERE ( coupon.coupon = '818' )
SELECT * FROM coupon WHERE ( coupon.v_name like '%Prieto%') AND (coupon.coupcat = 'V') AND  ( coupon.coupstat = 'I' ) --AND (coupon = 301089190) akoy nag add ani bai :D 

DECLARE @coupon VARCHAR(10)
SET @coupon = '7364'
UPDATE coupon
SET genmode ='0'
WHERE coupon.coupon = @coupon


--Genmode for Coupon Tagging
SELECT *
FROM coupon_list --WHERE v_name like '%Patricio%' AND genmode != 1 AND coupcat = 'E' AND coupon BETWEEN 819 AND 841
WHERE   (( coupon_list.coupon = 7359 ) AND  ( coupon_list.coupcat = 'E' ) AND (coupon_list.bldgid = 2))

DECLARE @couponlist VARCHAR(10)
SET @couponlist = '7364'
UPDATE coupon_list
SET genmode ='0'
WHERE coupon = @couponlist AND coupcat = 'E'

-- KANG CHARLS :D Para di nako mahilabtan imong queries
SELECT *
FROM coupon_list 
WHERE v_name like '%Patricio%' AND genmode != 1 AND coupcat = 'E' AND coupon BETWEEN 819 AND 841

UPDATE coupon_list
SET genmode = 0
WHERE v_name like '%Patricio%' AND genmode = 1 AND coupcat = 'E' AND coupon BETWEEN 819 AND 841

