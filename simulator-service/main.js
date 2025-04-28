// === API URLS ===
const API_BASE_URL = "http://localhost:8080";

const CARS_URL = `${API_BASE_URL}/telemetry/cars`;
const TELEMETRY_POST_URL = (carCode) =>
  `${API_BASE_URL}/telemetry/cars/${carCode}/readings`;

// === GLOBALS ===
let selectedCarCode = 1;
let carsData = [];

// === METRICS ===
const metricGroups = {
  "Tire Temperatures": [
    "tire_temp_fl",
    "tire_temp_fr",
    "tire_temp_rl",
    "tire_temp_rr",
  ],
  "Brake Temperatures": [
    "brake_temp_fl",
    "brake_temp_fr",
    "brake_temp_rl",
    "brake_temp_rr",
  ],
  Engine: ["engine_temp", "oil_temp", "fuel_level"],
  Performance: ["gear", "rpm", "speed", "throttle", "brake_pressure"],
  Forces: ["g_force_lat", "g_force_long"],
  "ERS/DRS": ["battery_voltage", "drs_status", "ers_deployment", "ers_charge"],
};

const metricRanges = {
  tire_temp_fl: [50, 150],
  tire_temp_fr: [50, 150],
  tire_temp_rl: [50, 150],
  tire_temp_rr: [50, 150],
  brake_temp_fl: [100, 1200],
  brake_temp_fr: [100, 1200],
  brake_temp_rl: [100, 1200],
  brake_temp_rr: [100, 1200],
  engine_temp: [60, 130],
  oil_temp: [60, 130],
  fuel_level: [0, 110],
  gear: [1, 8],
  rpm: [0, 15000],
  speed: [0, 380],
  throttle: [0, 100],
  brake_pressure: [0, 100],
  g_force_lat: [-5, 5],
  g_force_long: [-5, 5],
  battery_voltage: [11, 15],
  drs_status: [0, 1],
  ers_deployment: [0, 100],
  ers_charge: [0, 100],
};

const defaultValues = {};
for (const metric in metricRanges) {
  const [min, max] = metricRanges[metric];
  defaultValues[metric] = (min + max) / 2;
}

async function loadCars() {
  const response = await fetch(CARS_URL);
  const cars = await response.json();
  carsData = cars;
  const carSelect = document.getElementById("carSelect");
  carSelect.innerHTML = "";

  cars.forEach((car) => {
    const option = document.createElement("option");
    option.value = car.car_code;
    option.text = `${car.driver} (${car.chassis})`;
    carSelect.appendChild(option);
  });

  selectedCarCode = cars[0].car_code;
  carSelect.value = selectedCarCode;
  updateDriverInfo(selectedCarCode);

  carSelect.addEventListener("change", (e) => {
    selectedCarCode = parseInt(e.target.value);
    updateDriverInfo(selectedCarCode);
  });
}

function updateDriverInfo(carCode) {
  const car = carsData.find((c) => c.car_code === parseInt(carCode));
  if (car) {
    document.getElementById("driverImg").src = car.driver_photo_url;
    document.getElementById(
      "driverName"
    ).textContent = `#${car.car_code} ${car.driver}`;
  } else {
    document.getElementById("driverImg").src = "";
    document.getElementById("driverName").textContent = "";
  }
}

function createGroupedSliders() {
  const slidersDiv = document.getElementById("sliders");
  slidersDiv.innerHTML = "";

  Object.entries(metricGroups).forEach(([groupName, metrics]) => {
    const container = document.createElement("div");
    container.className = "bg-white rounded shadow p-2";

    container.innerHTML = `
      <h2 class="font-bold mb-2">${groupName}</h2>
      <div class="grid grid-cols-2 gap-2">
        ${metrics
          .map((metric) => {
            const [min, max] = metricRanges[metric];
            return `
            <div>
              <label for="${metric}" class="block text-xs font-semibold mb-1">${metric} (${min}-${max}): <span id="${metric}_val">${defaultValues[metric]}</span></label>
              <input type="range" id="${metric}" min="${min}" max="${max}" step="0.1" value="${defaultValues[metric]}" class="w-full h-2">
            </div>
          `;
          })
          .join("")}
      </div>
    `;
    slidersDiv.appendChild(container);
  });

  Object.values(metricGroups)
    .flat()
    .forEach((metric) => {
      const slider = document.getElementById(metric);
      const valSpan = document.getElementById(`${metric}_val`);
      slider.addEventListener("input", () => {
        valSpan.innerText = slider.value;
      });
    });
}

function getTelemetryReadings() {
  return Object.values(metricGroups)
    .flat()
    .map((metric) => {
      const value = parseFloat(document.getElementById(metric).value);
      return { metric: metric, value: value };
    });
}

function sendTelemetry() {
  const readings = getTelemetryReadings();
  fetch(TELEMETRY_POST_URL(selectedCarCode), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ readings: readings }),
  })
    .then((response) => {
      if (!response.ok) {
        console.error("Failed to send telemetry", response.statusText);
      }
    })
    .catch((err) => console.error("Error:", err));
}

loadCars().then(() => {
  createGroupedSliders();
  setInterval(sendTelemetry, 1000);
});
