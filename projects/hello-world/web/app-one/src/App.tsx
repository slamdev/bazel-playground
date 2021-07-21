import * as React from "react";
import styled from "styled-components";
import System from './System'
import Text from "./Text";
import Box from "./Box";

const Container = styled.div`
   font-family: sans-serif;
   max-width: 640px;
   margin: 0 auto;
   height: 100%;
 `;

export const App = () => {
    return (
        <System>
            <Container>
                <Box>
                    <Text as="h1" color="purple">Hello</Text>
                    <Text as="h2" color="teal">Let's build a styled system!</Text>
                </Box>
            </Container>
        </System>
    );
};
