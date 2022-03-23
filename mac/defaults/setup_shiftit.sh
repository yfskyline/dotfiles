#!/bin/env bash

# Move Left
defaults write org.shiftitapp.ShiftIt leftKeyCode -int 123
defaults write org.shiftitapp.ShiftIt leftModifiers -int 9437184

# Move Right
defaults write org.shiftitapp.ShiftIt rightKeyCode -int 124
defaults write org.shiftitapp.ShiftIt rightModifiers -int 9437184

# tr
defaults write org.shiftitapp.ShiftIt trKeyCode -int 18
defaults write org.shiftitapp.ShiftIt trModifiers -int 786432

# tl
defaults write org.shiftitapp.ShiftIt tlKeyCode -int 19
defaults write org.shiftitapp.ShiftIt tlModifiers -int 786432

# bl
defaults write org.shiftitapp.ShiftIt blKeyCode -int 20
defaults write org.shiftitapp.ShiftIt blModifiers -int 786432

# br
defaults write org.shiftitapp.ShiftIt blKeyCode -int 21
defaults write org.shiftitapp.ShiftIt blModifiers -int 786432
