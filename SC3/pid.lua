pid = {}

-- local kp = 0.15
-- local ki = 0
-- local kd = 0
-- local bias = 0
--
-- local timer = (GAME_TIMER_DEFAULT - GAME_TIMER)
-- local desiredrads = PLAYER.STOP_HEADING    -- desired heading
-- local error = desiredrads - currentrads
-- local derivative = (error - lastError) / timer
-- integralSum = integralSum + (error * timer)
-- local output = (kp * error) + (ki * integralSum) + (kd * derivative)
--
-- lastError = error
--
-- local angularvelocity = physEntity.body:getAngularVelocity()
--
-- local appliedangularthrust = output
-- if appliedangularthrust > 1 then appliedangularthrust = 1 end
-- if appliedangularthrust < -1 then appliedangularthrust = -1 end
--
--



return pid
