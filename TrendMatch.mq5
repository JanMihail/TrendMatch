#include "Logger.mqh"
#include "Trade.mqh"

//--- input parameters
input double STOP_LOSS_IN_PIPS = 0.00150;
input double RISK_PERCENT = 1;
input double RISK_REWARD = 1.5;

bool isOpenedFirstDeal = false;
enum Direction {UP, DOWN} direction = UP;
bool isLastPositionOpenedSuccess = true;


namespace TrendMatch {

int OnInit() {
    Logger::info("Initialize...");
    Logger::info("Initialize complete!");
    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    Logger::info("Deinitialize...");
    // deinit();
    Logger::info("Deinitialize complete! ReasonCode: " + IntegerToString(reason));
}

void OnTick() {
    if (isOpenedFirstDeal) {
        mainLogic();
        return;
    }

    bool res = Trade::openLong(STOP_LOSS_IN_PIPS, RISK_PERCENT, RISK_REWARD);

    if (res) {
        isOpenedFirstDeal = true;
        direction = UP;
    }
}

void mainLogic() {
    if (PositionsTotal() > 0) {
        return;
    }

    if (isLastPositionOpenedSuccess && !Trade::isLastDealProfit()) {
        direction = direction == UP ? DOWN : UP;
    }
    
    if (direction == UP) {
        isLastPositionOpenedSuccess = Trade::openLong(STOP_LOSS_IN_PIPS, RISK_PERCENT, RISK_REWARD);
    } else {
        isLastPositionOpenedSuccess = Trade::openShort(STOP_LOSS_IN_PIPS, RISK_PERCENT, RISK_REWARD);
    }
}

}