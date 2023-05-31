        within Examples;

model SimpleBatteryCharging
  "An external battery charger respecting the limits from the battery pack controller."
  extends .Modelon.Icons.Experiment;
  .Electrification.Loads.Examples.BatteryCharger charger(
    enable_thermal_port=false,
    display_name=true,
    core(vTh=0.1))
    annotation (Placement(transformation(extent={{-20,-20},{-60,20}})));

  .Electrification.Batteries.Examples.Applications.ElectricCar battery(
    ns=100,
    np=26,
    redeclare .Electrification.Batteries.Core.Examples.Modular core(
      vCellMax=4.15,
      vCellMin=2.0,
      iCellMaxDch=11,
      iCellMaxCh=11,
      capacity(Q_cap_cell_nom=20000),
      voltage(vCell_high=4.1, vCell_low=3.3),
      impedance(R0=0.05)),
    redeclare .Electrification.Batteries.Control.LimitsFixed controller(
        SoC_limits=false),
    SOC_start=0.1,
    enable_thermal_port=false,
    display_name=true,
    fixed_temperature=true,
    limitActionSoC=.Modelon.Types.FaultAction.Terminate)
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
equation
  connect(charger.controlBus, battery.controlBus) annotation (Line(
      points={{-24,20},{24,20}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(charger.plug_a, battery.plug_a) annotation (Line(
      points={{-20,0},{20,0}},
      color={255,128,0},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p>This example demonstrates a battery pack connected to an external charger. The battery charger respects the maximum allowed power, current and voltage limits. The controller of the charger has been configured to listen to the limits reported by the controller of the battery pack. The battery pack has a controller that reports power, current and voltage limits, with power being de-rated for high temperatures.</p>
<p>This example demonstrates the common functionality for handling component limits.</p>
<h4>Charging process</h4>
<p>The plots below show that the battery is initially being charged with the maximum allowed current, until the current is reduced due to high temperature. When the voltage limit is reached, the current slowly decrease to zero as the SoC settles to a steady level.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_BatteryCharging_i.png\"/></p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_BatteryCharging_T.png\"/></p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_BatteryCharging_v.png\"/></p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_BatteryCharging_SoC.png\"/></p>
<h4>Charger model</h4>
<p>The charger is based on the CurrentSourcePower load model. It has a capacitor in the electrical domain interface, to ensure a linear system of equations when connecting it to different battery models. There is also a diode on the electrical interface, to enforce positive output power and avoid excessive initial current transients. This means that the charger will first charge the capacitor, before it can provide power to a battery, as seen in the plots below.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_BatteryCharging_vCapacitor.png\"/></p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_BatteryCharging_iCapacitor.png\"/></p>
</html>",revisions="<html><!--COPYRIGHT--></html>"), experiment(StopTime=6900),
    uses(Modelon(version="4.1"), Electrification(version="1.8")));
end SimpleBatteryCharging;
