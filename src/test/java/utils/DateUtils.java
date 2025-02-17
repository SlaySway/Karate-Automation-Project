package utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtils {

    public DateUtils(){

    }

    /**
     * @param dateString - formatted as "yyyy-MM-dd"
     * @param daysToAdd - amount of days to add
     * @return date with added days formatted as "yyyy-MM-dd"
     *
     * possible improvements: option for format, new function with option for day/week/month/year additions
     */
    public static String addDays(String dateString, int daysToAdd) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate convertedDate = LocalDate.parse(dateString, formatter);
        convertedDate = convertedDate.plusDays(daysToAdd);
        return convertedDate.format(formatter);
    }

    /**
     *
     * @param beginDateString - beginning range formatted as "yyyy-MM-dd"
     * @param endDateString - ending range formatted as "yyyy-MM-dd"
     * @return true if current date is between range (inclusive), false otherwise
     *
     * possible improvements: option for format, option for inclusive/exclusive
     */
    public static Boolean isCurrentDateBetweenTwoDates(String beginDateString, String endDateString){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate beginDate = LocalDate.parse(beginDateString, formatter);
        LocalDate endDate = LocalDate.parse(endDateString, formatter);
        return !LocalDate.now().isBefore(beginDate) && !LocalDate.now().isAfter(endDate);
    }

    public static String convertFormat(String dateTime, String originalFormat, String newFormat){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(originalFormat);
        ZonedDateTime originalDate = ZonedDateTime.parse(dateTime, formatter);
        DateTimeFormatter newFormatter = DateTimeFormatter.ofPattern(newFormat);
        return originalDate.format(newFormatter);
    }

    public static String convertFormat(String dateTime, String originalFormat, String newFormat, String newTimezone){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(originalFormat);
        ZonedDateTime originalDate = ZonedDateTime.parse(dateTime, formatter);
        ZonedDateTime convertedZone = originalDate.withZoneSameInstant(ZoneId.of(newTimezone));
        DateTimeFormatter newFormatter = DateTimeFormatter.ofPattern(newFormat);
        return convertedZone.format(newFormatter);
    }

}
