DROP PROCEDURE IF EXISTS PopulateDimDate;
DROP TABLE IF EXISTS `DimDate`;
CREATE TABLE `DimDate` (
   `DateKey` INT NOT NULL,
   `Date` DATE NOT NULL,
   `Day` TINYINT NOT NULL,
   `DaySuffix` CHAR(2) NOT NULL,
   `Weekday` TINYINT NOT NULL,
   `WeekDayName` VARCHAR(10) NOT NULL,
   `WeekDayName_Short` CHAR(3) NOT NULL,
   `WeekDayName_FirstLetter` CHAR(1) NOT NULL,
   `DOWInMonth` TINYINT NOT NULL,
   `DayOfYear` SMALLINT NOT NULL,
   `WeekOfMonth` TINYINT NOT NULL,
   `WeekOfYear` TINYINT NOT NULL,
   `Month` TINYINT NOT NULL,
   `MonthName` VARCHAR(10) NOT NULL,
   `MonthName_Short` CHAR(3) NOT NULL,
   `MonthName_FirstLetter` CHAR(1) NOT NULL,
   `Quarter` TINYINT NOT NULL,
   `QuarterName` VARCHAR(6) NOT NULL,
   `Year` INT NOT NULL,
   `MMYYYY` CHAR(6) NOT NULL,
   `MonthYear` CHAR(8) NOT NULL,
   `IsWeekend` BIT NOT NULL,
   `IsHoliday` BIT NOT NULL,
   `HolidayName` VARCHAR(50) NULL,
   `SpecialDays` VARCHAR(50) NULL,
   `FirstDateofYear` DATE NULL,
   `LastDateofYear` DATE NULL,
   `FirstDateofMonth` DATE NULL,
   `LastDateofMonth` DATE NULL,
   PRIMARY KEY (`DateKey`)
);
DELIMITER $$

CREATE PROCEDURE PopulateDimDate(IN StartDate DATE, IN EndDate DATE)
BEGIN
    DECLARE CurrentDate DATE;
    SET CurrentDate = StartDate;

    WHILE CurrentDate <= EndDate DO
        INSERT INTO `DimDate` (
            `DateKey`, `Date`, `Day`, `DaySuffix`, `Weekday`, `WeekDayName`, `WeekDayName_Short`, `WeekDayName_FirstLetter`,
            `DOWInMonth`, `DayOfYear`, `WeekOfMonth`, `WeekOfYear`, `Month`, `MonthName`, `MonthName_Short`, `MonthName_FirstLetter`,
            `Quarter`, `QuarterName`, `Year`, `MMYYYY`, `MonthYear`, `IsWeekend`, `IsHoliday`, `FirstDateofYear`, `LastDateofYear`,
            `FirstDateofMonth`, `LastDateofMonth`
        )
        SELECT
            DATE_FORMAT(CurrentDate, '%Y%m%d'),
            CurrentDate,
            DAY(CurrentDate),
            CASE
                WHEN DAY(CurrentDate) IN (1, 21, 31) THEN 'st'
                WHEN DAY(CurrentDate) IN (2, 22) THEN 'nd'
                WHEN DAY(CurrentDate) IN (3, 23) THEN 'rd'
                ELSE 'th'
            END,
            DAYOFWEEK(CurrentDate),
            DAYNAME(CurrentDate),
            UPPER(LEFT(DAYNAME(CurrentDate), 3)),
            LEFT(DAYNAME(CurrentDate), 1),
            DAYOFMONTH(CurrentDate),
            DAYOFYEAR(CurrentDate),
            FLOOR((DAYOFMONTH(CurrentDate) - 1) / 7) + 1, -- Week of Month calculation
            WEEKOFYEAR(CurrentDate),
            MONTH(CurrentDate),
            MONTHNAME(CurrentDate),
            UPPER(LEFT(MONTHNAME(CurrentDate), 3)),
            LEFT(MONTHNAME(CurrentDate), 1),
            QUARTER(CurrentDate),
            CASE QUARTER(CurrentDate)
                WHEN 1 THEN 'First'
                WHEN 2 THEN 'Second'
                WHEN 3 THEN 'Third'
                WHEN 4 THEN 'Fourth'
            END,
            YEAR(CurrentDate),
            DATE_FORMAT(CurrentDate, '%m%Y'),
            DATE_FORMAT(CurrentDate, '%Y-%b'),
            CASE WHEN DAYNAME(CurrentDate) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END,
            0, -- Default IsHoliday to 0
            MAKEDATE(YEAR(CurrentDate), 1), -- First day of year
            STR_TO_DATE(CONCAT('12/31/', YEAR(CurrentDate)), '%m/%d/%Y'), -- Last day of year
            DATE_FORMAT(CurrentDate, '%Y-%m-01'), -- First day of month
            LAST_DAY(CurrentDate); -- Last day of month

        SET CurrentDate = DATE_ADD(CurrentDate, INTERVAL 1 DAY);
    END WHILE;

    -- Update Holiday information
    UPDATE DimDate SET IsHoliday = 1, HolidayName = 'Christmas' WHERE Month = 12 AND Day = 25;
    UPDATE DimDate SET SpecialDays = 'Valentines Day' WHERE Month = 2 AND Day = 14;

END$$

-- Reset the delimiter back to the default
DELIMITER ;