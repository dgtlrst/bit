use crate::frb_generated::StreamSink;
use anyhow::{anyhow, Result};
use serde::{Deserialize, Serialize};
use serde_json;
use serialport::Error;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_list_available_ports() {
        let ports = list_available_ports().unwrap();
        // println!("{:?}", ports);
        // print the ports
        for p in &ports {
            println!("Port: {}", p.name);
        }

        // assert that ports is not empty
        assert!(!ports.is_empty());
    }
}
