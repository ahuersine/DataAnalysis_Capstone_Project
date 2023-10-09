--Sipariş Analizi
--En çok hangi dönemde sipariş alınmış?Ay ve yıl bazında sipariş dağılımlarını analiz edelim

select to_char(order_date,'YYYY-MM') as order_month,count(o.order_id) as order_count
from orders as o 
left join order_details as od on o.order_id=od.order_id
group by 1 order by 2 desc

--Kategori Analizi
--Siparişlerin kategori bazında dağılımını ve her kategoride alınan sipariş adetlerini analiz edelim.

select to_char(order_date,'YYYY-MM') as order_month,count(distinct o.order_id) as order_count,c.category_name 
from orders as o
left join order_details as od on o.order_id=od.order_id
left join products as p on od.product_id=p.product_id
left join categories as c on p.category_id=c.category_id
where c.category_name is not null
group by 1,3 order by 1 

--Gelir Analizi 
--Ülke bazında siparişlerden elde edilen toplam geliri analiz edelim.

select cast(sum(od.unit_price * od.quantity * (1 - od.discount)) as decimal(18,2)),country
from customers c
left join orders as o on c.customer_id = o.customer_id
left join order_details as od on o.order_id = od.order_id
group by 2 order by 1 desc

--Çalışan Analizi
--Çalışan bazında sipariş ve gelir dağılımlarını analiz edelim.

select count(distinct o.order_id) as order_count,cast(sum(od.unit_price * od.quantity * (1 - od.discount)) as decimal(18,2)) as revenue,
concat(e.first_name,' ',e.last_name) as employee_name,e.country
from order_details  as od
left join orders as o on o.order_id=od.order_id
left join employees as e on o.employee_id=e.employee_id
group by 3,4 order by 2 desc

--Lojistik Analizi
--Siparişlerin lojistik şirketleri arasında dağılımını ve navlun bedellerini firmalara göre analiz edelim.

select count(o.order_id) as order_count,sum(freight) as total_freight,avg(freight) as avg_freight,sh.company_name
from orders as o 
left join shippers as sh on o.ship_via=sh.shipper_id
group by 4

--Ürün Fiyat Analizi
--Hangi ürünler daha karlı ve hangi üründen ne kadar gelir elde edilmiş analiz edelim.

select cast(sum(od.unit_price * od.quantity * (1 - od.discount)) as decimal(18,2)) as product_profit,p.product_name
from orders as o
left join order_details as od on o.order_id=od.order_id
left join products as p on od.product_id=p.product_id
where product_name is not null
group by 2 order by 1 desc
