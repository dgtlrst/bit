use serde::{Deserialize, Serialize};
use serde_json;

#[derive(Clone, Serialize, Deserialize, Debug, Copy)]
pub enum DataBits {
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8,
}

impl From<DataBits> for serialport::DataBits {
    #[flutter_rust_bridge::frb(sync)]
    fn from(data_bits: DataBits) -> Self {
        match data_bits {
            DataBits::Five => serialport::DataBits::Five,
            DataBits::Six => serialport::DataBits::Six,
            DataBits::Seven => serialport::DataBits::Seven,
            DataBits::Eight => serialport::DataBits::Eight,
        }
    }
}

#[derive(Clone, Serialize, Deserialize, Copy, Debug)]
pub enum Parity {
    None,
    Odd,
    Even,
}

impl From<Parity> for serialport::Parity {
    #[flutter_rust_bridge::frb(sync)]
    fn from(parity: Parity) -> Self {
        match parity {
            Parity::None => serialport::Parity::None,
            Parity::Odd => serialport::Parity::Odd,
            Parity::Even => serialport::Parity::Even,
        }
    }
}

#[derive(Clone, Serialize, Deserialize, Debug, Copy)]
pub enum StopBits {
    One,
    Two,
}

impl From<StopBits> for serialport::StopBits {
    #[flutter_rust_bridge::frb(sync)]
    fn from(stop_bits: StopBits) -> Self {
        match stop_bits {
            StopBits::One => serialport::StopBits::One,
            StopBits::Two => serialport::StopBits::Two,
        }
    }
}
#[derive(Clone, Serialize, Deserialize, Debug, Copy)]
pub enum FlowControl {
    None,
    Software,
    Hardware,
}

impl From<FlowControl> for serialport::FlowControl {
    #[flutter_rust_bridge::frb(sync)]
    fn from(flow_control: FlowControl) -> Self {
        match flow_control {
            FlowControl::None => serialport::FlowControl::None,
            FlowControl::Software => serialport::FlowControl::Software,
            FlowControl::Hardware => serialport::FlowControl::Hardware,
        }
    }
}

#[flutter_rust_bridge::frb(opaque)]
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct SerialPortInfo {
    pub name: String,
    pub speed: u32,
    pub data_bits: DataBits,
    pub parity: Parity,
    pub stop_bits: StopBits,
    pub flow_control: FlowControl,
}

impl SerialPortInfo {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(
        name: String,
        speed: u32,
        data_bits: DataBits,
        parity: Parity,
        stop_bits: StopBits,
        flow_control: FlowControl,
    ) -> Self {
        Self {
            name,
            speed,
            data_bits,
            parity,
            stop_bits,
            flow_control,
        }
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn from_json(json: String) -> Option<Self> {
        let serial_port_info = serde_json::from_str(&json);
        return match serial_port_info {
            Ok(valid) => {
                return Some(valid);
            }
            Err(e) => {
                println!("{:?}", e);
                None
            }
        };
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_json(&self) -> Option<String> {
        let serial_port_info_as_str = serde_json::to_string(&self);
        return match serial_port_info_as_str {
            Ok(valid) => {
                return Some(valid);
            }
            Err(e) => {
                println!("{:?}", e);
                None
            }
        };
    }
}

impl Into<serialport::SerialPortBuilder> for SerialPortInfo {
    fn into(self) -> serialport::SerialPortBuilder {
        serialport::new(self.name, self.speed)
            .stop_bits(self.stop_bits.into())
            .parity(self.parity.into())
            .flow_control(self.flow_control.into())
            .data_bits(self.data_bits.into())
    }
}
