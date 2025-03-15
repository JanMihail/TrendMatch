//###<Experts/TrendMatch/TrendMatch.mq5>

namespace TrendMatch {

class LotCalculator {

public:
    static double calcFixedRisk(double stopLossInPips, double riskInMoney) {
        double tickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
        double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
        double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);

        double moneyPerLotStep = stopLossInPips / tickSize * tickValue * lotStep;
        double lots = floor(riskInMoney / moneyPerLotStep) * lotStep;
        return NormalizeDouble(lots, 2);
    }

    static double calcPercentRisk(double stopLossInPips, double riskPercent) {
        double riskInMoney = AccountInfoDouble(ACCOUNT_BALANCE) / 100 * riskPercent;
        return calcFixedRisk(stopLossInPips, riskInMoney);
    }
};

}