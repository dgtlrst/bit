use serialport::Error;

pub enum DataBits {
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8
}

impl From<DataBits> for serialport::DataBits {
    #[flutter_rust_bridge::frb(sync)]
    fn from(data_bits: DataBits) -> Self {
        match data_bits {
            DataBits::Five => serialport::DataBits::Five,
            DataBits::Six => serialport::DataBits::Six,
            DataBits::Seven => serialport::DataBits::Seven,
            DataBits::Eight => serialport::DataBits::Eight
        }
    }
}

pub enum Parity {
    None,
    Odd,
    Even
}

impl From<Parity> for serialport::Parity {
    #[flutter_rust_bridge::frb(sync)]
    fn from(parity: Parity) -> Self {
        match parity {
            Parity::None => serialport::Parity::None,
            Parity::Odd => serialport::Parity::Odd,
            Parity::Even => serialport::Parity::Even
        }
    }
}

pub enum StopBits {
    One,
    Two
}

impl From<StopBits> for serialport::StopBits {
    #[flutter_rust_bridge::frb(sync)]
    fn from(stop_bits: StopBits) -> Self {
        match stop_bits {
            StopBits::One => serialport::StopBits::One,
            StopBits::Two => serialport::StopBits::Two
        }
    }
}

pub enum FlowControl {
    None,
    Software,
    Hardware
}

impl From<FlowControl> for serialport::FlowControl {
    #[flutter_rust_bridge::frb(sync)]
    fn from(flow_control: FlowControl) -> Self {
        match flow_control {
            FlowControl::None => serialport::FlowControl::None,
            FlowControl::Software => serialport::FlowControl::Software,
            FlowControl::Hardware => serialport::FlowControl::Hardware
        }
    }
}


pub struct SerialPortInfo {
    pub name: String,
    pub speed: u32,
    pub data_bits: DataBits,
    pub parity: Parity,
    pub stop_bits: StopBits,
    pub flow_control: FlowControl
}

impl SerialPortInfo {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(name: String, speed: u32, data_bits: DataBits, parity: Parity, stop_bits: StopBits, flow_control: FlowControl) -> Self {
        Self {
            name,
            speed,
            data_bits,
            parity,
            stop_bits,
            flow_control
        }
    }

    // pub fn convert(&self) -> serialport::SerialPortInfo {
    //     panic!("Not implemented yet");
    // }
}

pub fn list_available_ports() -> Result<Vec<serialport::SerialPortInfo>, Error> {
    let ports = serialport::available_ports()?;
    Ok(ports)
}

fn main() {
    match list_available_ports() {
        Ok(ports) => {
            if !ports.is_empty() {
                for p in ports {
                    println!("Port: {}", p.port_name);
                }
            } else {
                println!("No ports found.");
            }
        },

        Err(e) => {
            println!("{:?}", e);
        }
    }
}



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_list_available_ports() {
        let ports = list_available_ports().unwrap();
        println!("{:?}", ports);

        assert!(!ports.is_empty());
    }
}
