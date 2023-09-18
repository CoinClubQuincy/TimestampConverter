// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimestampConverter {
    uint public startYear = 1970;
    uint public startMonth = 1;
    uint public startDay = 1;
    uint public startHour = 0;
    uint public startMinute = 0;
    uint public startSecond = 0;

    function currentDateTime() public view returns (uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) {
        return timestampToDateTime(block.timestamp);
    }

    function timestampToDateTime(uint256 timestamp) public view returns (uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) {
        require(timestamp >= 1, "Invalid timestamp");

        uint256 secondsInDay = 86400;
        uint256 secondsInHour = 3600;
        uint256 secondsInMinute = 60;

        year = uint16(startYear + (timestamp / (secondsInDay * 365)));

        uint256 secondsInYear = year % 4 == 0 ? 31622400 : 31536000;
        uint256 secondsInThisYear = timestamp % secondsInYear;

        uint8[12] memory daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        for (month = 1; month <= 12; month++) {
            uint256 daysInThisMonth = uint256(daysInMonth[month - 1]) * secondsInDay;
            if (month == 2 && year % 4 == 0) {
                daysInThisMonth += secondsInDay;
            }

            if (secondsInThisYear < daysInThisMonth) {
                day = uint8(1 + secondsInThisYear / secondsInDay);
                uint256 secondsInThisDay = secondsInThisYear % secondsInDay;
                hour = uint8(startHour + secondsInThisDay / secondsInHour);
                minute = uint8(startMinute + (secondsInThisDay % secondsInHour) / secondsInMinute);
                second = uint8(startSecond + secondsInThisDay % secondsInMinute);
                break;
            }

            secondsInThisYear -= daysInThisMonth;
        }
    }
}

contract TimestampSubnetConverter is TimestampConverter{
    constructor(uint _startYear,uint _startMonth,uint _startDay,uint _startHour,uint _startMinute,uint _startSecond){
    startYear = _startYear;
    startMonth = _startMonth;
    startDay = _startDay;
    startHour = _startHour;
    startMinute = _startMinute;
    startSecond = _startSecond;
    }
}

