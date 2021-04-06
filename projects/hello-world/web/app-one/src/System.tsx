import * as React from "react";
import {ThemeProvider} from "styled-components";

const theme = {
    colors: {
        orange: "#e28413",
        teal: "#baf2d8",
        purple: "#44344f",
        red: "#ef233c",
        tan: "#fff8f0"
    },
    fontSizes: [12, 14, 16, 18, 20, 24, 32],
    fontWeights: [100, 300, 500, 700, 900]
};

const System: React.FC<{}> = ({children}) => (
    <ThemeProvider theme={theme}>{children}</ThemeProvider>
);

export default System;
