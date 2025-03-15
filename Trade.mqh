//###<Experts/TrendMatch/TrendMatch.mq5>

#include "Logger.mqh"
#include "LotCalculator.mqh"
#include <Trade/Trade.mqh>

namespace TrendMatch {

class Trade {

public:
    static bool openLong(double stopLossInPips, double riskPercent, double riskReward) {
        double lot = LotCalculator::calcPercentRisk(stopLossInPips, riskPercent);

        Logger::info(StringFormat("openLong. stopLossInPips=%G, lot=%G", stopLossInPips, lot));

        double openPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
        double stopLoss = openPrice - stopLossInPips;
        double takeProfit = openPrice + stopLossInPips * riskReward;

        CTrade trade;
        bool res = trade.Buy(0.01, Symbol(), 0.0, stopLoss, takeProfit);

        if (!res) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
        }

        return res;
    }

    static bool openShort(double stopLossInPips, double riskPercent, double riskReward) {
        double lot = LotCalculator::calcPercentRisk(stopLossInPips, riskPercent);

        Logger::info(StringFormat("openShort. stopLossInPips=%G, lot=%G", stopLossInPips, lot));

        double openPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
        double stopLoss = openPrice + stopLossInPips;
        double takeProfit = openPrice - stopLossInPips * riskReward;

        CTrade trade;
        bool res = trade.Sell(lot, Symbol(), 0.0, stopLoss, takeProfit);

        if (!res) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
        }

        return res;
    }

    static bool isLastDealProfit() {
        HistorySelect(0, TimeCurrent());
        int n = HistoryDealsTotal();

        if (n <= 1) {
            return true;
        }

        for (int i = n - 1; i > 0; i--) {
            ulong dealTicket = HistoryDealGetTicket(i);
            long entry = HistoryDealGetInteger(dealTicket, DEAL_ENTRY);

            if (entry != ENUM_DEAL_ENTRY::DEAL_ENTRY_OUT) {
                continue;
            }

            double profit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
            Logger::info(StringFormat("n = %G, dealTicket = %G, profit = %G", n, dealTicket, profit));

            return profit >= 0;
        }

        return true;
    }
};

}