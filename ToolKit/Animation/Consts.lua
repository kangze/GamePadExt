local sin = math.sin;
local cos = math.cos;
local pow = math.pow;
local pi = math.pi;


---缓动函数
--t: total time elapsed
--b: beginning position
--e: ending position
--d: animation duration
function Linear(t, b, e, d)
    return (e - b) * t / d + b
end

function OutSine(t, b, e, d)
    return (e - b) * sin(t / d * (pi / 2)) + b
end

function InOutSine(t, b, e, d)
    return -(e - b) / 2 * (cos(pi * t / d) - 1) + b
end

function OutQuart(t, b, e, d)
    t = t / d - 1;
    return (b - e) * (pow(t, 4) - 1) + b
end

function OutQuint(t, b, e, d)
    t = t / d
    return (b - e) * (pow(1 - t, 5) - 1) + b
end

function InQuad(t, b, e, d)
    t = t / d
    return (e - b) * pow(t, 2) + b
end

EasingFunctions = {
    Linear = Linear,
    OutSine = OutSine,
    InOutSine = InOutSine,
    OutQuart = OutQuart,
    OutQuint = OutQuint,
    InQuad = InQuad,
}