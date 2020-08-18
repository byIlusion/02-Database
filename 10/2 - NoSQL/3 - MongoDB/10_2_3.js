/**
* Задание 3.
* Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
*/
// Все команды будут выполняться из консоли

// Просмотр доступных БД
show dbs;

// Выбираем БД gb_shop по-умолчанию
use gb_shop;

// Добавляем каталоги
db.catalogs.insertMany(
  [
    {catalog_id: 1, name: 'Процессоры'},
    {catalog_id: 2, name: 'Материнские платы'},
    {catalog_id: 3, name: 'Видеокарты'},
    {catalog_id: 4, name: 'Жесткие диски'},
    {catalog_id: 5, name: 'Оперативная память'}
  ]
);

// Добавляем товары
db.products.insertMany(
  [
    {
      product_id: 1,
      name: 'Intel Core i3-8100',
      description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel',
      price: 7890.00,
      catalog_id: 1,
      catalog_name: 'Процессоры',
      created_at: 1596746789,
      updated_at: 1596746789
    },
    {
      product_id: 1,
      name: 'Intel Core i5-7400',
      description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel',
      price: 12700.00,
      catalog_id: 1,
      catalog_name: 'Процессоры',
      created_at: 1596746789,
      updated_at: 1596746789
    },
    {
      product_id: 1,
      name: 'AMD FX-8320E',
      description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD',
      price: 4780.00,
      catalog_id: 1,
      catalog_name: 'Процессоры',
      created_at: 1596746789,
      updated_at: 1596746789
    },
    {
      product_id: 1,
      name: 'ASUS ROG MAXIMUS X HERO',
      description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
      price: 19310.00,
      catalog_id: 2,
      catalog_name: 'Материнские платы',
      created_at: 1596746789,
      updated_at: 1596746789
    },
    {
      product_id: 1,
      name: 'Gigabyte H310M S2H',
      description: 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX',
      price: 4790.00,
      catalog_id: 2,
      catalog_name: 'Материнские платы',
      created_at: 1596746789,
      updated_at: 1596746789
    }
  ]
);


// Поиск товаров категории 1 (Процессоры)
db.products.find({catalog_id: 1});

// Поиск товаров категории 1 (Процессоры) и стоимостью меньше 10000.
db.products.find({$and:[{catalog_id: 1}, {price: {$lt: 10000}}]});
