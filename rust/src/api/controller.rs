use std::collections::HashMap;
use std::sync::Mutex;
use std::{thread, time::Duration};

use crate::frb_generated::StreamSink;
use anyhow::{anyhow, bail, Ok, Result};
use flutter_rust_bridge::frb;
use rand::prelude::*;
use serialport::Error;
use std::sync::mpsc::{self, Receiver, Sender};
use std::thread::JoinHandle;

struct TerminalRunner {
    thread_id: u32,
    stream: StreamSink<String>,
    receiver: Receiver<String>,
}
impl TerminalRunner {
    fn new(thread_id: u32, stream: StreamSink<String>, receiver: Receiver<String>) -> Self {
        TerminalRunner {
            thread_id,
            stream,
            receiver,
        }
    }

    fn main(&self) {
        let start = std::time::Instant::now();
        let mut count = 0;
        loop {
            let received_data = self.receiver.try_recv();
            match received_data {
                std::result::Result::Ok(data) => {
                    self.stream
                        .add(format!("Thread: {:?}, Echoing {:?}", self.thread_id, data));
                }
                Err(e) => match e {
                    std::sync::mpsc::TryRecvError::Empty => {}
                    std::sync::mpsc::TryRecvError::Disconnected => {
                        println!("Terminating Thread {:?}", self.thread_id);
                        break;
                    }
                },
            }
            let instant = std::time::Instant::now();
            let time_since_start = instant.duration_since(start);
            let msgs_missed_since_start = time_since_start.as_secs() - count;
            if msgs_missed_since_start > 0 {
                println!(
                    "Thread Controller {:?}: Time since start: {:?}, Msgs missed since start: {:?}",
                    self.thread_id,
                    time_since_start.as_secs().to_string(),
                    (msgs_missed_since_start as i64 - 1).to_string()
                );
                for _i in 0..msgs_missed_since_start {
                    match self.stream.add(format!(
                        "Thread: {:?}: {:?}",
                        self.thread_id, time_since_start
                    )) {
                        std::result::Result::Ok(_) => {} // Succesfully Sent Message
                        Err(_) => {
                            println!(
                                "Thread Controller {:?}: Something went wrong.",
                                self.thread_id
                            );
                        }
                    };
                    count += 1;
                }
            }

            std::thread::sleep(Duration::from_millis(1))
        }
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub struct TerminalController {
    thread_id: u32,
    thread_handle: Option<JoinHandle<()>>,
    thread_transmitter: Option<Box<Sender<String>>>,
}
impl TerminalController {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(thread_id: u32) -> Self {
        TerminalController {
            thread_id: thread_id,
            thread_handle: None,
            thread_transmitter: None,
        }
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn create_stream(&mut self, stream_sink: StreamSink<String>) {
        // Create stream should always be used in tandem with get_latest_thread_created
        let thread_closure =
            move |thread_id: u32, stream_sink: StreamSink<String>, rx: Receiver<String>| {
                let thread_controller = TerminalRunner::new(thread_id, stream_sink, rx);
                thread_controller.main();
            };
        let (tx, rx) = mpsc::channel();
        let thread_id = self.thread_id;
        let handle = thread::spawn(move || thread_closure(thread_id, stream_sink, rx));
        self.thread_transmitter = Some(Box::new(tx));
        self.thread_handle = Some(handle);
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn end_stream(&mut self) {
        self.thread_transmitter = None;
        let handle = self.thread_handle.take();
        match handle {
            Some(handle) => match handle.join() {
                std::result::Result::Ok(_) => {
                    println!("Thread successfully joined!");
                }
                Err(_) => {
                    println!("Thread failed to join!");
                }
            },
            None => {
                println!("Controller: end_stream -> Handle does not exist. This is a logical Error. Ignoring for stability.");
            }
        };
        self.thread_handle = None;
        // Remove transmitter
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn push(&self, data: String) -> Result<()> {
        let tx = &self.thread_transmitter;
        match tx {
            Some(sender) => match sender.send(data) {
                std::result::Result::Ok(_) => return Ok(()),
                Err(_) => return Err(anyhow!("Receiver disconnected!")),
            },
            None => Err(anyhow!("Receiver does not exist!")),
        }
    }
}
